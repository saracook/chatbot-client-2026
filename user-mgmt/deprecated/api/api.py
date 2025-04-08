#!/usr/bin/python3
# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Flask API running on Anthos Bare Metal to Create, Read, Update, & Delete Carina users"""
import os
import json
import subprocess
import shlex
import shutil
import random
import string
import logging

from flask import jsonify, request, make_response, Flask
from flaskext.mysql import MySQL
from flask_cors import CORS
from git import Repo
from datetime import datetime

# Initializations
app = Flask(__name__)
CORS(app)
app.config["DEBUG"] = True
logging.getLogger('flask_cors').level = logging.DEBUG
mysql = MySQL()
PROJECT_ID = "srcc-anthos-secure-prod"
SERVICE_ACCOUNT_NAME = "carina-user-management@srcc-anthos-secure-prod.iam.gserviceaccount.com"
SERVICE_ACCOUNT_KEY = "/etc/sa/user-mgmt-key.json"
ACM_REPO_NAME = "carina-user-management-acm"


# MySQL configurations
app.config["MYSQL_DATABASE_USER"] = "root"
app.config["MYSQL_DATABASE_PASSWORD"] = os.getenv("db_root_password")
app.config["MYSQL_DATABASE_DB"] = os.getenv("db_name")
app.config["MYSQL_DATABASE_HOST"] = os.getenv("MYSQL_SERVICE_HOST")
app.config["MYSQL_DATABASE_PORT"] = int(os.getenv("MYSQL_SERVICE_PORT"))
mysql.init_app(app)


# Test if Carina User Management API is running
@app.route("/")
def index():
    return 'Carina User Management API up-and-running!'


@app.route("/create", methods=["POST"])
def add_user():
    """Function to create new Carina user(s)"""
    
    JOB_ID = "".join(random.choices(string.ascii_lowercase, k=5))
    JOB_TIME = datetime.now()
    CREATE_JOB_BRANCH = f"create-users-{JOB_ID}"
    input_user_count = 0
    written_user_count = 0
    
    # Authenticate gcloud CLI with Carina User Management service account
    authenticate_service_account()

    # Extract user information from JSON request
    input_data = request.get_json()
    user_list = input_data["users"]
    input_user_count = len(user_list)
    for input_user in user_list:
        user_sunet_id = input_user["user"]["user_sunet_id"].lower()
        user_first_name = input_user["user"]["user_first_name"]
        user_last_name = input_user["user"]["user_last_name"]
        email = f"{user_sunet_id}@stanford.edu"
        pi_sunet_id = input_user["pi_sunet_id"].lower()
        app.logger.debug(f"User Sunet ID: {user_sunet_id}, User Name: {user_first_name} {user_last_name}, User Email: {email}, PI Sunet ID: {pi_sunet_id}")
        user_status = ""
        pi_group_status = ""
        pi_group_member_status = ""
        user_id = 0
        pi_group_id = 0

        # Check if PI group already exists in MySQL
        existing_pi_group = {}
        if pi_sunet_id and request.method == "POST":
            existing_pi_group= does_pi_group_exist(pi_sunet_id)
            if existing_pi_group is not None:
                existing_pi_group_status = existing_pi_group.get_json()[2]
                if existing_pi_group_status == "DEACTIVATED" or existing_pi_group_status == "FAILED":
                    return jsonify(f"ERROR: PI group already exists and is in an a DEACTIVATED or FAILED state! Please either activate the PI group or delete the PI group before trying again.")
                elif existing_pi_group_status == "PENDING":
                    app.logger.debug("WARNING: PI group already exists and is in a PENDING state. Please wait a few moments for the User Creation Job to complete before trying again.")
                elif existing_pi_group_status == "ACTIVE":
                    pi_group_status = "ACTIVE"
                    app.logger.debug("PI group already exists and is in an ACTIVE state. User can be added to the existing PI group")
            else:
                app.logger.debug("PI group does not yet exist. A new record will be created in the pi_groups table")
                pi_group_status = "PENDING"
                # Insert new user in MySQL pi_groups table with a PENDING status
                insert_new_pi_group(pi_sunet_id, pi_group_status, JOB_ID, JOB_TIME)
        else:
            return jsonify("ERROR: Please provide the PI SUNET ID for the PI group that the new user(s) will be members of") 


        # Check if user already exists in MySQL
        existing_user = {}
        if user_sunet_id and user_first_name and user_last_name and request.method == "POST":
            existing_user = does_user_exist(user_sunet_id)
            if existing_user is not None:
                existing_user_status = existing_user.get_json()[5]
                if existing_user_status == "DEACTIVATED" or existing_user_status == "FAILED":
                    return jsonify(f"ERROR: User already exists and is in a DEACTIVATED or FAILED state! Please either activate the user or delete the user before trying again.")
                elif existing_user_status == "PENDING":
                    user_status = "PENDING"
                    return jsonify("WARNING: User already exists and is in an PENDING state. Please wait a few moments for the User Creation Job to complete.")
                elif existing_user_status == "ACTIVE":
                    user_status = "ACTIVE"
                    app.logger.debug("User already exists and is in an ACTIVE state. Will next check if user is already a member of the PI group")
                    
                    # Check if user already is a member of this PI group in MySQL
                    existing_member = is_user_member(existing_pi_group.get_json()[0], existing_user.get_json()[0])
                    
                    if existing_member is not None:
                        existing_member_status = existing_member.get_json()[3]
                        if existing_member_status == "DEACTIVATED" or existing_member_status == "FAILED":
                            return jsonify(f"ERROR: PI group membership already exists and is in a DEACTIVATED or FAILED state! Please either activate the membership or delete the membership before trying again.")
                        elif existing_member_status == "PENDING":
                            pi_group_member_status = "PENDING"
                            return jsonify("WARNING: PI group membership already exists and is in an PENDING state. Please wait a few moments for the User Creation Job to complete.")
                        elif existing_member_status == "ACTIVE":
                            pi_group_member_status = "ACTIVE"
                            return jsonify("User already exists and their membership to the specified PI group is in an ACTIVE state.")
                    
            else:
                user_status = "PENDING"
                app.logger.debug("User does not yet exist. A new record will be created in the MySQL Users")
                # Insert new user in MySQL users table with a PENDING status
                insert_new_user(user_sunet_id, user_first_name, user_last_name, email, user_status, JOB_ID, JOB_TIME)
            

            # Insert new membership in MySQL pi_group_members table with a PENDING status
            pi_group_member_status = "PENDING"
            app.logger.debug("New/Existing user already exists but their membership to the specified PI group does not. A new record will be created in the MySQL pi_group_members table.")

            user_id = get_user_id(user_sunet_id)
            pi_group_id = get_pi_group_id(pi_sunet_id)

            # Insert new user into their own PI Group and the nero_users (2000000) PI Group
            insert_member_in_group(pi_group_id, user_id, pi_group_member_status, JOB_ID, JOB_TIME)
            insert_member_in_group(2000000, user_id, pi_group_member_status, JOB_ID, JOB_TIME)
        else:
            return jsonify("Please provide users SUNET ID, first name, last name, and PI group SUNET ID")

        app.logger.debug("Finished input validation and starting to modify extrausers config!")

    # Cleanup container workspace
    try:
        os.remove("group")
        os.remove("gshadow")
        os.remove("passwd")
        os.remove("shadow")
        shutil.rmtree(f"{ACM_REPO_NAME}")
    except Exception as exception:
        app.logger.debug(f"WARNING: Cleaning up container workspace failed. Can proceed with creating new extrausers files.")

    # Generating new extrausers config to include the new users
    try:
        written_user_count = update_extrausers_files()
        app.logger.debug(f"Wrote {written_user_count} users to extrausers config files")
    except Exception as exception:
        return jsonify(f"ERROR: Failed to generate new extrausers config files | {exception}")
    
    # Clone ACM repo to container local directory
    try:
        repo_clone_command = f"gcloud source repos clone {ACM_REPO_NAME} --project={PROJECT_ID}"
        subprocess.check_output(shlex.split(repo_clone_command))
        app.logger.debug("Cloned ACM repo using gcloud command")
    except Exception as exception:
        return jsonify(f"ERROR: Cloning ACM repo to container local directory failed | {exception}")
    
    # Checkout ACM repo main branch and create branch for this user creation job
    acm_repo = Repo(ACM_REPO_NAME)
    acm_repo.config_writer().set_value("user", "name", "User Automation API SA").release()
    acm_repo.config_writer().set_value("user", "email", "{SERVICE_ACCOUNT_NAME}").release()
    git = acm_repo.git
    git.checkout("-b", "main")
    git.pull("origin", "main")
    git.checkout("-b", CREATE_JOB_BRANCH)
    app.logger.debug("Created new branch")

    for new_user in user_list:
        new_user_sunet_id = new_user["user"]["user_sunet_id"].lower()
        # Add new user's SUNET ID to users/kustomization.yaml
        try:
            with open(f"{ACM_REPO_NAME}/users/kustomization.yaml", "a") as users_index:
                users_index.write(f"\n- {new_user_sunet_id}")
        except Exception as exception:
            return jsonify(f"ERROR: Writing user to users/kustomization.yaml failed | {exception}")

        # Create new user's patch directory and kustomization file
        try:
            os.mkdir(f"{ACM_REPO_NAME}/users/{new_user_sunet_id}")
            shutil.copyfile(f"{ACM_REPO_NAME}/scripts/new_user_kustomization.yaml", f"{ACM_REPO_NAME}/users/{new_user_sunet_id}/kustomization.yaml")
        except Exception as exception:
            return jsonify(f"ERROR: Creating new user's patch directory failed | {exception}")

        # Replace {{SUNET_ID}} in the new user's patch kustomization file
        try:
            with open(f"{ACM_REPO_NAME}/users/{new_user_sunet_id}/kustomization.yaml", "r") as new_user_kustomization_template:
                data = new_user_kustomization_template.read()
                data = data.replace("{{SUNET_ID}}", new_user_sunet_id)
            with open(f"{ACM_REPO_NAME}/users/{new_user_sunet_id}/kustomization.yaml", "w") as new_user_kustomization:
                new_user_kustomization.write(data)
        except Exception as exception:
            return jsonify(f"ERROR: Replacing SUNET_ID in the new user's patch file failed | {exception}")
    
    # Move newly-generated extrausers files to ACM repo
    try:
        shutil.copyfile("group", f"{ACM_REPO_NAME}/base/configmaps/group")
        shutil.copyfile("gshadow", f"{ACM_REPO_NAME}/base/configmaps/gshadow")
        shutil.copyfile("passwd", f"{ACM_REPO_NAME}/base/configmaps/passwd")
        shutil.copyfile("shadow", f"{ACM_REPO_NAME}/base/configmaps/shadow")
    except Exception as exception:
        return jsonify(f"ERROR: Moving newly-generated extrausers files to ACM failed | {exception}")

    # Stage and commit changes to remote branch without merging into main
    try:
        git.add(".")
        git.commit("-m", f"Added {written_user_count} new users to ther ACM repo")
        git.push("origin", CREATE_JOB_BRANCH)
    except Exception as exception:
        return jsonify(f"ERROR: Stage and commit to remote branch failed | {exception}")

    # Trigger Cloud Build pipeline to modify extrausers
    try:
        build_trigger_command = f"gcloud builds submit  --no-source --config=cloudbuild-merge-user-changes.yaml --substitutions=_JOB_BRANCH={CREATE_JOB_BRANCH},REPO_NAME={ACM_REPO_NAME} --async"
        subprocess.check_output(shlex.split(build_trigger_command))
        app.logger.debug("Submitted Cloud Build pipeline")
    except Exception as exception:
        return jsonify(f"ERROR: Submitting Cloud Build pipeline failed | {exception}") 

    # Update database status
    for finished_user in user_list:
        user_sunet_id = finished_user["user"]["user_sunet_id"].lower()
        pi_sunet_id = finished_user["pi_sunet_id"].lower()
        user_id = get_user_id(user_sunet_id)
        pi_group_id = get_pi_group_id(pi_sunet_id)
        try:
            update_user_status(user_sunet_id, 'ACTIVE')
            update_pi_group_status(pi_sunet_id, 'ACTIVE')
            update_member_pi_status(user_id, pi_group_id, 'ACTIVE')
            update_member_pi_status(user_id, 2000000, 'ACTIVE')
        except Exception as exception:
            return jsonify(f"ERROR: Updating database status failed | {exception}") 
    
    # Return a 200 SUCCESS response to the User Create API call
    success_response = make_response("SUCCESS: User creation job submitted. The process should complete soon...")
    success_response.status_code = 200
    success_response.headers['Access-Control-Allow-Origin'] = 'http://localhost:8080'
    return success_response

@app.route("/users", methods=["GET"])
def list_users():
    """Function to retrieve all Carina users from the MySQL database"""

    users_list = []

    try:
        conn = mysql.connect()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM users")
        users_results = cursor.fetchall()
        for result in users_results:
            obj = {}
            obj["user_id"] = result[0]
            obj["user_sunet_id"] = result[1]
            obj["user_first_name"] = result[2]
            obj["user_last_name"] = result[3]
            obj["user_email"] = result[4]
            obj["user_status"] = result[5]
            obj["job_id"] = result[6]
            obj["job_time"] = result[7]
            users_list.append(obj)
        cursor.close()
        conn.close()
        resp = jsonify(users_list)
        resp.status_code = 200
        resp.headers['Access-Control-Allow-Origin'] = 'http://localhost:8080'
        return resp
    except Exception as exception:
        return jsonify(str(exception))


@app.route("/pi_groups", methods=["GET"])
def list_pi_groups():
    """Function to retrieve all PI groups from the MySQL database"""
    try:
        conn = mysql.connect()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM pi_groups")
        rows = cursor.fetchall()
        cursor.close()
        conn.close()
        resp = jsonify(rows)
        resp.status_code = 200
        resp.headers['Access-Control-Allow-Origin'] = 'http://localhost:8080'
        return resp
    except Exception as exception:
        return jsonify(str(exception))


@app.route("/user/<user_sunet_id>", methods=["GET"])
def get_user(user_sunet_id):
    """Function to get information of a specific Carina user in the MySQL database"""
    try:
        conn = mysql.connect()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM users WHERE user_sunet_id = %s", user_sunet_id)
        row = cursor.fetchone()
        cursor.close()
        conn.close()
        resp = jsonify(row)
        resp.status_code = 200
        resp.headers['Access-Control-Allow-Origin'] = 'http://localhost:8080'
        return resp
    except Exception as exception:
        return jsonify(str(exception))


@app.route("/update", methods=["POST"])
def update_user():
    """Function to update a Carina user in the MYSQL database"""
    json = request.json
    user_id = json["user_id"]
    user_sunet_id = json["user_sunet_id"]
    user_first_name = json["user_first_name"]
    user_last_name = json["user_last_name"]
    email = f"{user_sunet_id}@stanford.edu"
    user_status = json["status"]
    
    if user_id and user_sunet_id and request.method == "POST":
        sql = "UPDATE users SET user_sunet_id=%s, user_first_name=%s, user_last_name=%s, user_email=%s, user_status=%s " \
              "WHERE user_id=%s AND user_sunet_id=%s"
        data = (user_sunet_id, user_first_name, user_last_name, email, user_status)
        try:
            conn = mysql.connect()
            cursor = conn.cursor()
            cursor.execute(sql, data)
            conn.commit()
            resp = jsonify("User updated successfully!")
            resp.status_code = 200
            cursor.close()
            conn.close()
            return resp
        except Exception as exception:
            return jsonify(str(exception))
    else:
        return jsonify("You must include at least the User ID (1XXXXXX) and User SUNET ID in your input JSON object.")


# User/PI group deactivation
@app.route("/deactivate/user/<user_sunet_id>", methods=["POST"])
def deactivate_user(user_sunet_id):
    """Function to deactivate a Carina user from the system"""
    
    JOB_ID = "".join(random.choices(string.ascii_lowercase, k=5))
    JOB_TIME = datetime.now()
    DEACTIVATE_JOB_BRANCH = f"deactivate-users-{JOB_ID}"
    
    # Authenticate gcloud CLI with Carina User Management service account
    authenticate_service_account()

    existing_user = {}
    if user_sunet_id and request.method == "POST":
        existing_user = does_user_exist(user_sunet_id)
        if existing_user is not None:
            existing_user_status = existing_user.get_json()[5];
            existing_user_id = existing_user.get_json()[0];
            if  existing_user_status in ('PENDING', 'ACTIVE'):
                update_user_status(user_sunet_id, 'DEACTIVATED')
                update_member_all_status(existing_user_id, 'DEACTIVATED')
            else:
                return jsonify("ERROR: User is already deactivated/deleted")
        else:
            return jsonify("ERROR: User does not yet exist")
    else:
        return jsonify("ERROR: Please provide users SUNET ID")

    app.logger.debug("Finished input validation and starting to modify extrausers config!")

    # Cleanup container workspace
    try:
        os.remove("group")
        os.remove("gshadow")
        os.remove("passwd")
        os.remove("shadow")
        shutil.rmtree(f"{ACM_REPO_NAME}")
    except Exception as exception:
        app.logger.debug(f"WARNING: Cleaning up container workspace failed. Can proceed with creating new extrausers files.")
    
    # Generating new extrausers config to include the deactivated user
    try:
        deactivation_success = update_extrausers_files()
        app.logger.debug(f"Extra Users Group file status: {deactivation_success}")
    except Exception as exception:
        return jsonify(f"ERROR: Failed to generate new extrausers config files | {exception}")

    # Clone ACM repo to container local directory
    try:
        repo_clone_command = f"gcloud source repos clone {ACM_REPO_NAME} --project={PROJECT_ID}"
        subprocess.check_output(shlex.split(repo_clone_command))
        app.logger.debug("Cloned ACM repo using gcloud command")
    except Exception as exception:
        return jsonify(f"ERROR: Cloning ACM repo to container local directory failed | {exception}")

    # Checkout ACM repo main branch and create branch for this user creation job
    acm_repo = Repo(ACM_REPO_NAME)
    acm_repo.config_writer().set_value("user", "name", "User Automation API SA").release()
    acm_repo.config_writer().set_value("user", "email", "{SERVICE_ACCOUNT_NAME}").release()
    git = acm_repo.git
    git.checkout("-b", "main")
    git.pull("origin", "main")
    git.checkout("-b", DEACTIVATE_JOB_BRANCH)
    app.logger.debug("Created new branch")

    # Move newly-generated extrausers files to ACM repo
    try:
        shutil.copyfile("group", f"{ACM_REPO_NAME}/base/configmaps/group")
        shutil.copyfile("gshadow", f"{ACM_REPO_NAME}/base/configmaps/gshadow")
        shutil.copyfile("passwd", f"{ACM_REPO_NAME}/base/configmaps/passwd")
        shutil.copyfile("shadow", f"{ACM_REPO_NAME}/base/configmaps/shadow")
    except Exception as exception:
        return jsonify(f"ERROR: Moving newly-generated extrausers files to ACM failed | {exception}")

    # Stage and commit changes to remote branch without merging into main
    try:
        git.add(".")
        git.commit("-m", f"Added the following user to ACM repo: {existing_user.get_json()[2]} {existing_user.get_json()[3]} ({user_sunet_id})")
        git.push("origin", DEACTIVATE_JOB_BRANCH)
    except Exception as exception:
        return jsonify(f"ERROR: Stage and commit to remote branch failed | {exception}")

    # Trigger Cloud Build pipeline to modify extrausers
    try:
        build_trigger_command = f"gcloud builds submit  --no-source --config=cloudbuild-merge-user-changes.yaml --substitutions=_JOB_BRANCH={DEACTIVATE_JOB_BRANCH},REPO_NAME={ACM_REPO_NAME} --async"
        subprocess.check_output(shlex.split(build_trigger_command))
        app.logger.debug("Submitted Cloud Build pipeline")
    except Exception as exception:
        return jsonify(f"ERROR: Submitting Cloud Build pipeline failed | {exception}")

    # Return a 200 SUCCESS response to the User Deactivate API call
    success_response = make_response("SUCCESS: User deactivation job submitted. The process should complete soon...")
    success_response.status_code = 200
    return success_response  


# Helper functions
def insert_new_pi_group(pi_sunet_id, pi_group_status, job_id, job_time):
    sql = "INSERT INTO pi_groups(pi_sunet_id, pi_group_status, job_id, job_time) " \
        "VALUES(%s, %s, %s, %s)"
    data = (pi_sunet_id, pi_group_status, job_id, job_time)
    try:
        conn = mysql.connect()
        cursor = conn.cursor()
        cursor.execute(sql, data)
        conn.commit()
        cursor.close()
        conn.close()
    except Exception as exception:
        return jsonify(str(exception))

def insert_new_user(user_sunet_id, user_first_name, user_last_name, user_email, user_status, job_id, job_time):
    sql = "INSERT INTO users(user_sunet_id, user_first_name, user_last_name, user_email, user_status, job_id, job_time) " \
        "VALUES(%s, %s, %s, %s, %s, %s, %s)"
    data = (user_sunet_id, user_first_name, user_last_name, user_email, user_status, job_id, job_time)
    try:
        conn = mysql.connect()
        cursor = conn.cursor()
        cursor.execute(sql, data)
        conn.commit()
        cursor.close()
        conn.close()
    except Exception as exception:
        return jsonify(str(exception))

def insert_member_in_group(pi_group_id, member_id, member_status, job_id, job_time):
    try:
        conn = mysql.connect()
        cursor = conn.cursor()
        cursor.execute(f"INSERT INTO pi_group_members(pi_group_id, member_id, member_status, job_id, job_time) VALUES ('{pi_group_id}', '{member_id}', '{member_status}', '{job_id}', '{job_time}')")
        conn.commit()
        cursor.close()
        conn.close()
        app.logger.debug("Added new/existing users to group membership")
    except Exception as exception:
        return jsonify(str(exception))

def update_extrausers_files():
    pi_groups_list = []
    users_list = []

    try:
        conn = mysql.connect()
        cursor = conn.cursor()
        cursor.execute("SELECT pi_group_id, pi_sunet_id FROM pi_groups WHERE pi_group_status in ('PENDING', 'ACTIVE')")
        pi_groups_results = cursor.fetchall()
        for result in pi_groups_results:
            obj = {}
            obj["pi_group_id"] = result[0]
            obj["pi_sunet_id"] = result[1]
            cursor.execute(f"SELECT members.user_sunet_id FROM pi_group_members membership LEFT JOIN users members ON membership.member_id = members.user_id WHERE membership.pi_group_id = {obj['pi_group_id']} AND membership.member_status in ('PENDING', 'ACTIVE') AND members.user_status in ('PENDING', 'ACTIVE')")
            pi_group_members_results = cursor.fetchall()
            members_list = ','.join(map(lambda x: x[0],pi_group_members_results))
            app.logger.debug(members_list)
            obj["pi_group_members"] = members_list
            pi_groups_list.append(obj)
        cursor.close()
        conn.close()
    except Exception as exception:
        return jsonify(f"ERROR: Could not fetch all PI Groups from database | {exception}")

    try:
        conn = mysql.connect()
        cursor = conn.cursor()
        cursor.execute("SELECT user_id, user_sunet_id, user_first_name, user_last_name FROM users WHERE user_status in ('PENDING', 'ACTIVE')")
        users_results = cursor.fetchall()
        for result in users_results:
            obj = {}
            obj["user_id"] = result[0]
            obj["user_sunet_id"] = result[1]
            obj["user_first_name"] = result[2]
            obj["user_last_name"] = result[3]
            users_list.append(obj)
        cursor.close()
        conn.close()
    except Exception as exception:
        return jsonify(f"ERROR: Could not fetch all Users from database | {exception}")

    group_file = open("group", "a")
    gshadow_file = open("gshadow", "a")
    passwd_file = open("passwd", "a")
    shadow_file = open("shadow", "a")

    for group_json in pi_groups_list:
        pi_sunet_id = group_json["pi_sunet_id"]
        pi_group_id = group_json["pi_group_id"]
        pi_group_members = group_json["pi_group_members"]

        group_line = f"{pi_sunet_id}:x:{pi_group_id}:{pi_group_members}\n"
        group_file.write(group_line)

        gshadow_line = f"{pi_sunet_id}:!::{pi_group_members}\n"
        gshadow_file.write(gshadow_line)


    for user_json in users_list:
        user_sunet_id = user_json["user_sunet_id"]
        user_id = user_json["user_id"]
        user_first_name = user_json["user_first_name"]
        user_last_name = user_json["user_last_name"]

        group_line = f"{user_sunet_id}:x:{user_id}:\n"
        group_file.write(group_line)

        gshadow_line = f"{user_sunet_id}:!::\n"
        gshadow_file.write(gshadow_line)

        passwd_line = f"{user_sunet_id}:x:{user_id}:{user_id}:{user_first_name} {user_last_name},,,:/home/{user_sunet_id}:/bin/bash\n"
        passwd_file.write(passwd_line)

        shadow_line = f"{user_sunet_id}:*:17734:0:99999:7:::\n"
        shadow_file.write(shadow_line)

    group_file.close()
    gshadow_file.close()
    passwd_file.close()
    shadow_file.close()

    return len(users_list)

def does_pi_group_exist(pi_sunet_id):
    try:
        conn = mysql.connect()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM pi_groups WHERE pi_sunet_id = %s", pi_sunet_id)
        row = cursor.fetchone()
        cursor.close()
        conn.close()
        if row == None:
            return None
        else:
            pi_group_response = jsonify(row)
            return pi_group_response
    except Exception as exception:
        return jsonify(str(exception))

def does_user_exist(user_sunet_id):
    try:
        conn = mysql.connect()
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM users WHERE user_sunet_id = %s", user_sunet_id)
        row = cursor.fetchone()
        cursor.close()
        conn.close()
        if row == None:
            return None
        else:
            user_response = jsonify(row)
            return user_response
    except Exception as exception:
        return jsonify(str(exception))

def is_user_member(pi_group_id, user_id):
    try:
        conn = mysql.connect()
        cursor = conn.cursor()
        cursor.execute(f"SELECT * FROM pi_group_members WHERE pi_group_id = {pi_group_id} AND member_id = {user_id}")
        row = cursor.fetchone()
        cursor.close()
        conn.close()
        if row == None:
            return None
        else:
            member_response = jsonify(row)
            return member_response
    except Exception as exception:
        return jsonify(str(exception))

def get_user_id(user_sunet_id):
    try:
        conn = mysql.connect()
        cursor = conn.cursor()
        cursor.execute("SELECT user_id FROM users WHERE user_sunet_id = %s", user_sunet_id)
        row = cursor.fetchone()
        cursor.close()
        conn.close()
        user_id_response = jsonify(row)
        return user_id_response.get_json()[0]
    except Exception as exception:
        return jsonify(str(exception))

def get_pi_group_id(pi_sunet_id):
    try:
        conn = mysql.connect()
        cursor = conn.cursor()
        cursor.execute("SELECT pi_group_id FROM pi_groups WHERE pi_sunet_id = %s", pi_sunet_id)
        row = cursor.fetchone()
        cursor.close()
        conn.close()
        pi_group_id_response = jsonify(row)
        return pi_group_id_response.get_json()[0]
    except Exception as exception:
        return jsonify(str(exception))

def update_user_status(user_sunet_id, status):
    try:
        conn = mysql.connect()
        cursor = conn.cursor()
        sql = "UPDATE users SET user_status = %s WHERE user_sunet_id = %s"
        data = (status, user_sunet_id)
        cursor.execute(sql, data)
        conn.commit()
        cursor.close()
        conn.close()
    except Exception as exception:
        return jsonify(str(exception))

def update_pi_group_status(pi_sunet_id, status):
    try:
        conn = mysql.connect()
        cursor = conn.cursor()
        sql = "UPDATE pi_groups SET pi_group_status = %s WHERE pi_sunet_id = %s"
        data = (status, pi_sunet_id)
        cursor.execute(sql, data)
        conn.commit()
        cursor.close()
        conn.close()
    except Exception as exception:
        return jsonify(str(exception))

def update_member_pi_status(user_id, pi_group_id, status):
    try:
        conn = mysql.connect()
        cursor = conn.cursor()
        sql = "UPDATE pi_group_members SET member_status = %s WHERE member_id = %s AND pi_group_id = %s"
        data = (status, user_id, pi_group_id)
        cursor.execute(sql, data)
        conn.commit()
        cursor.close()
        conn.close()
    except Exception as exception:
        return jsonify(str(exception))

def update_member_all_status(user_id, status):
    try:
        conn = mysql.connect()
        cursor = conn.cursor()
        sql = "UPDATE pi_group_members SET member_status = %s WHERE member_id = %s"
        data = (status, user_id)
        cursor.execute(sql, data)
        conn.commit()
        cursor.close()
        conn.close()
    except Exception as exception:
        return jsonify(str(exception))

def authenticate_service_account():
    # Authenticate gcloud CLI with Carina User Management service account
    try:
        gcloud_auth_command = f"gcloud auth activate-service-account {SERVICE_ACCOUNT_NAME} --key-file={SERVICE_ACCOUNT_KEY}"
        gcloud_project_command = f"gcloud config set project {PROJECT_ID}"
        subprocess.check_output(shlex.split(gcloud_auth_command))
        subprocess.check_output(shlex.split(gcloud_project_command))
        app.logger.debug("Authenticated gcloud CLI")
    except Exception as exception:
        return jsonify(f"ERROR: Authentication gcloud CLI with service account / project | {exception}")

if __name__ == "__main__":
    if app.debug: use_debugger = True
    app.run(use_debugger=use_debugger, debug=app.debug,
            use_reloader=use_debugger, host='0.0.0.0', port=5000)

# Delete - remove from extrausers and delete NS and resources from the cluster - warn
