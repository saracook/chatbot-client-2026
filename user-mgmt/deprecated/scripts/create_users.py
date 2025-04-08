import requests
import json
import csv

user_list = []
with open("new_users.csv", "r") as user_file:
    csvreader = csv.reader(user_file)
    header = next(csvreader)
    for row in csvreader:
      user_payload = {
        'user': {
          'user_sunet_id': row[0],
          'user_first_name':row[1],
          'user_last_name':row[2]
        },
        'pi_sunet_id':row[3]
      }
      user_list.append(user_payload)


head = { "Content-type" : "application/json" }
user_payload_list = {
  "users": user_list
}
r = requests.post('http://10.112.1.230:5000/create', headers = head, data = json.dumps(user_payload_list))
print(r.text)
