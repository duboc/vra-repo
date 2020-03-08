import requests
import os 

def login():
    key = 'TVZyycfqz3wwUi499XOhpeDFwYLm69GSmk4AUVuF9GJrZ9SA4IVq6C38B91lTuS8'
    baseurl = 'https://console.cloud.vmware.com/csp/gateway'
    uri = '/am/api/auth/api-tokens/authorize'
    headers = {'Content-Type':'application/json'}
    payload = {'refresh_token': key}
    r = requests.post(f'{baseurl}{uri}', headers = headers, params = payload)
    if r.status_code != 200:
        print(f'Unsuccessful Login Attmept. Error code {r.status_code}')
    else:
        print('Login successful. ')
        auth_json = r.json()['access_token']
        auth_Header = {'Content-Type':'application/json','csp-auth-token':auth_json}
        return auth_Header
      
auth_header = login()
orgList = requests.get('https://vmc.vmware.com/vmc/api/orgs', headers = auth_header)
orgID = orgList.json()[0]['id']
sddcList = requests.get(f'https://vmc.vmware.com/vmc/api/orgs/{orgID}/sddcs', headers = auth_header)
if sddcList.status_code != 200:
    print('API Error')
else:
    for sddc in sddcList.json():
        print("SDDC Name: " + sddc['name'])
        print("SDDC Create Date: " + sddc['created'])
        print("SDDC Provider: " + sddc['provider'])
        print("SDDC Region: " + sddc['resource_config']['region'])
