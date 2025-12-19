from stanford.mais.client import MAISClient
from stanford.mais.workgroup import WorkgroupClient
import requests
import argparse
import os
import urllib3
import subprocess
import grp
# import logging
import sys
import time

'''
Standing questions:
1) if/else in main statement always runs else unless exit(0) is added. Why is that?
2) Better error handling in try/excepts
3) Consider creating /ifs/carina-dev
'''

# Setting this disables the warning messages that get created from verify=False.
urllib3.disable_warnings()

# Credentials for reaching h700 cluster
DELL_ROOT_PW = os.getenv('DELL_ROOT_PASSWORD')

# Leaving this here for posterity in case we want to circle back on executing this script locally.
# proxies = {
#    'http': 'socks5://localhost:8126',
#    'https': 'socks5://localhost:8126'
# }

# Production certs
DEFAULT_CERT = './c2-wgm-api-client.pem'
DEFAULT_KEY = './c2-wgm-api-prod.key'

# UAT certs (dev)
DEBUG_CERT = './carina-app.pem'
DEBUG_KEY = './carina.key'


def get_workgroup(wg_name, cert, key):
    """
    Function to query the Workgroup manager API and get data regarding a specific Workgroup
    """
    print(f"Gathering workgroup data for {wg_name}")
    try:
        client = MAISClient.prod(cert, key)
        wclient = WorkgroupClient(client)
        sysadmin = wclient.get(wg_name)
        return (sysadmin)
    except Exception as e:
        print(f"an error occurred: {e}")


def create_workgroup(wg_name, members, cert, key):
    """
    Function to create a new Workgroup (POST) via the Workgroup manager API
    This function is a bit involved, as it handles multiple steps.
    The steps are the following:
    1) Create the Workgroup.
    2) Nest the Workgroup under carina:users
    2) Populate the new Wokgroup with the members.
    3) Set the posix attribute via remctl.
    """
    # Pre-requisite - ensure a krb5 root tab is populated in the envrionment
    try:
        k_ticket = subprocess.run(
            ["klist"], capture_output=True, text=True, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Subprocess failed with exit code {e.returncode}")
        print(f"Error output: {e.stderr}")
        print("Please check and ensure your environment has a kerberos root ticket")
        sys.exit(e.returncode)

    # First create the workgroup
    try:
        client = MAISClient.prod(cert, key)
        print(f"Sending request to create {wg_name}")
        wclient = WorkgroupClient(client)
        if f'{wg_name}' not in wclient:
            new_workgroup = wclient.create(
                name=f'{wg_name}', description='API test')
        else:
            print("Workgroup already exists.. Exiting now.")
            exit(7)
    except Exception as e:
        print(f"an error occurred: {e}")

    # Second, nest the newly created Workgroup under carina:users so they can access the cluster
    try:
        carina_users_wg = wclient.get('carina:users')
        carina_users_wg.members.workgroups.add(f'{wg_name}')
    except Exception as e:
        print(f"an error occurred: {e}")

    # Third, populate the workgroup with members (according to the docs these must be separate steps)
    try:
        users = wclient.get(wg_name)
        for new_users in members:
            print(f'adding user {new_users} to {wg_name}')
            users.members.people.add(new_users)
    except Exception as e:
        print(f"an error occurred: {e}")

    # Lastly, set the POSIX attribute via remctl
    # Note - the use of 'check=True' here handles whether or not a 'CalledProcessError' is thrown. If so, the program exits
    print("Setting POSIX attribute... Sleeping for 30 seconds to allow group to populate.")
    time.sleep(30)
    try:
        # print("Setting POSIX attribute for the Workgroup in LDAP")
        posix_attr = subprocess.run(
            ["remctl", "ldap-tools-prod", "posixgroup", "add", f"{wg_name}"], capture_output=True, text=True, check=True)
        print(f"Successfulyl set POSIX attribute for {wg_name}")
    except subprocess.CalledProcessError as e:
        print(f"Subprocess failed with exit code {e.returncode}")
        print(f"Error output: {e.stderr}")


def add_wg_member(wg_name, members, cert, key):
    """
    Function to add users to an existing workgroup
    """
    print(f"Gathering workgroup data for {wg_name}")
    try:
        client = MAISClient.prod(cert, key)
        wclient = WorkgroupClient(client)
        users = wclient.get(wg_name)
        for new_users in members:
            print(f'adding user {new_users} to {wg_name}')
            users.members.people.add(new_users)
    except Exception as e:
        print(f"an error occurred: {e}")


def get_fs(url_param):
    """
    Function to get directory contents via the PowerScale API
    """
    username = "root"
    try:
        response = requests.get(
            f'https://h700.mgmt.carina:8080/namespace/ifs/carina-prod/{url_param}', verify=False, auth=(username, DELL_ROOT_PW), timeout=30)
        print(f"Status Code: {response.status_code}")
        print(response.json())
    except requests.exceptions.RequestException as e:
        print(f"An error occurred: {e}")


def get_fs_quota(pi_sunet, project):
    """
    Function to get the quota of a directory.
    """
    username = "root"
    password = f"{dell_root_pw}"
    json_payload = {
        "path": f"/ifs/carina-prod/projects/{pi_sunet}/{project}"}
    try:
        response = requests.get(
            f'https://h700.mgmt.carina:8080/platform/1/quota/quotas', params=json_payload, verify=False, auth=(username, password), timeout=30)
        print(f"Status Code: {response.status_code}")
        print(response.json())
    except requests.exceptions.RequestException as e:
        print(f"An error occurred: {e}")


def create_dir(pi, project):
    """
    Function to create a new directory and set the quota via the PowerScale API
    """
    isilon_username = "root"
    headers = {
        'x-isi-ifs-target-type': 'container',
        'x-isi-ifs-access-control': '3770'
    }
    directory_path = f'/ifs/carina-prod/projects/{pi}/{project}'

    dell_credential_check()

    try:
        response = requests.put(
            f'https://h700.mgmt.carina:8080/namespace{directory_path}?recursive=true', verify=False, headers=headers, auth=(username, DELL_ROOT_PW), timeout=30)
        print(
            f'Succesfully created the project directory at /ifs/carina-prod/projects/{pi}/{project}')
    except requests.exceptions.RequestException as e:
        print(f"An error occurred: {e}")

    # Set quota on newly created directory
    quota_payload = {
        "include_snapshots": False,
        "path": f'{directory_path}',
        "thresholds": {
            "hard": 1209462790553,
            "soft": 1099511627776,
            # soft_grace -- Time in seconds after which writes will be denied. This is required by the API to set a soft quota. Set to 1 week.
            "soft_grace": 604800,
        },
        "type": "directory"
    }
    try:
        quota = requests.post(
            f'https://h700.mgmt.carina:8080/platform/8/quota/quotas/', json=quota_payload, verify=False, auth=(username, DELL_ROOT_PW), timeout=30)
        print('Successfully set quota for new project directory to 1T')
    except requests.exceptions.RequestException as e:
        print(f"An error occurred: {e}")

    try:
        target_group_ownership = f"carina_{pi}-{project}"
        local_dir_path = f"/projects/{pi}/{project}"
        gid = grp.getgrnam(target_group_ownership).gr_gid
        uid = -1  # Set UID to -1 to ignore making any user ownership change on the directory
        os.chown(local_dir_path, uid, gid)
        print(
            f"Successfully changed group ownership of '{directory_path}' to '{target_group_ownership}' (GID: {gid})")
    except KeyError:
        print(f"Error: Group '{target_group_ownership}' not found.")
    except PermissionError:
        print("Error: Permission denied. You likely need superuser (root) privileges to change ownership.")
    except FileNotFoundError:
        print(f"Error: Directory not found at '{directory_path}'")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")


def update_quota(pi_sunet, project, soft_quota, hard_quota):
    """
    Function to update the quota of a project/directory.
    There are two parts to this function.
    1) We need to query the quota id from the API in order to make a modification. A string (directory path) cannot be used.
    2) Once the quota id is stored in a variable, we use this to perform the actual update of the quota
    """
    username = "root"
    payload = {
        "thresholds": {
            "hard": hard_quota,
            "soft": soft_quota,
            # soft_grace -- Time in seconds after which writes will be denied. This is required by the API to set a soft quota. Set to 1 week.
            "soft_grace": 604800,
        },
    }
    # First we need to retrieve the "id" of the quota in order to make an update. Unfortunately we cannot use the directory path as a parameter for updates.
    directory_path = {
        "path": f"/ifs/carina-prod/projects/{pi_sunet}/{project}"}
    try:
        response = requests.get(
            f'https://h700.mgmt.carina:8080/platform/1/quota/quotas', params=directory_path, verify=False, auth=(username, DELL_ROOT_PW), timeout=30)
        data = response.json()
        for keys in data['quotas']:
            quota_id = keys['id']
        if quota_id is not None:
            print("Quota id successfully queried. Updating Quota now..")
        else:
            print("The 'id' field was not found in the response")
    except requests.exceptions.RequestException as e:
        print(f"An error occurred: {e}")

    # Now that we have the quota id we can properly update the quota information
    try:
        response = requests.put(
            f'https://h700.mgmt.carina:8080/platform/1/quota/quotas/{quota_id}', json=payload, verify=False, auth=(username, DELL_ROOT_PW), timeout=30)
        print(f"Status Code: {response.status_code}")
        print(response.json())
    except requests.exceptions.RequestException as e:
        print(f"An error occurred: {e}")


def dell_credential_check():
    dell_password = os.getenv("DELL_ROOT_PW")
    if dell_password is None:
        print(f"Password not set for Isilon storage. Exiting now.. Please set this to continue")
        sys.exit(1)


def main():

    # Debug flag sets credentials for WG API to UAT URL

    parser = argparse.ArgumentParser(
        description="cli tool for manipulating workgroups and creating project directories")

    parser.add_argument('--debug', action="store_true",
                        help="Enable debug mode. Will query UAT instance instead of prod.")

    # Auto set credentials for WG API

    parser.add_argument('--certfile', type=str, default=DEFAULT_CERT,
                        help=f"Specify certificate file path(default: {DEFAULT_CERT})")
    parser.add_argument('--keyfile', type=str, default=DEFAULT_KEY,
                        help=f"Specify key file path(default: {DEFAULT_KEY})")

    # Sets PI sunet for workgroup creation and project folder creation

    parser.add_argument('--pi-sunet', dest='pi_sunet', type=str,
                        help="Sunet id for the PI")

    # Workgroup API Section

    parser.add_argument('--workgroup', dest='wg', type=str,
                        help="Workgroup to perform operations on")

    parser.add_argument('--get-workgroup', dest='get_wg', type=str,
                        help="Get workgroup member list")

    parser.add_argument('--create-workgroup', dest='create_wg', type=str,
                        help="Create new workgroup and populate the group with members. Combine this flag with --members to pass in the list of users.")

    parser.add_argument('--members', dest='wg_member', nargs='+',
                        help="Helper flag to populate newly created Workgroups with users")

    parser.add_argument('--add-wg-member', dest='add_wg', nargs='+',
                        help="Add members to an existing workgroup. Use this with the --workgroup flag to indicate which workgroup to perform operations on")

    # PowerScale OneFS API Section

    parser.add_argument('--get-filesystem', dest='get_fs', type=str,
                        help="Get contents of a directory from OneFS API")

    parser.add_argument('--get-filesystem-quota', dest='get_fs_quota', type=str,
                        help="Retrieve quota information for a directory/project")

    parser.add_argument('--create-directory', dest='create_dir', type=str,
                        help="Create a directory on the h700 cluster")

    parser.add_argument('--update-quota', dest='update_quota', type=str,
                        help="Update quota for a project/directory")

    parser.add_argument('--soft_quota', dest='soft_quota', type=int,
                        help="Value to be used for a projects soft quota on the H700 storage cluster")

    parser.add_argument('--hard_quota', dest='hard_quota', type=int,
                        help="Value to be used for a projects hard quota on the H700 storage cluster")

    args = parser.parse_args()

    if args.debug:
        print("Debug mode enabled. Using dev credentials and UAT endpoint")
        args.certfile = DEBUG_CERT
        args.keyfile = DEBUG_KEY

    if args.get_wg:
        group = get_workgroup(args.get_wg, args.certfile, args.keyfile)
        print(group)

    if args.create_wg:
        group = create_workgroup(
            args.create_wg, set(args.wg_member), args.certfile, args.keyfile)

    if args.add_wg:
        group = add_wg_member(args.wg, set(args.add_wg),
                              args.certfile, args.keyfile)

    if args.get_fs:
        result = get_fs(args.get_fs)
        print(result)

    if args.get_fs_quota:
        result = get_fs_quota(args.pi_sunet, args.get_fs_quota)
        print(result)

    if args.create_dir:
        result = create_dir(args.pi_sunet, args.create_dir)

    if args.update_quota:
        result = update_quota(args.pi_sunet, args.update_quota,
                              args.soft_quota, args.hard_quota)
        print(result)


if __name__ == "__main__":
    # logger statements can be used to debug the endpoint that the WG SDK hits.
    # logger = logging.getLogger(__name__)
    # logging.basicConfig(filename="example.txt", level=logging.DEBUG)
    main()
