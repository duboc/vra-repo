import requests


def secao(nsxURL, auth):
    url = f"https://{nsxURL}/api/v1/firewall/sections/" 

    headers = {
      'Authorization': f'Basic {auth}',
      'Host': 'nsxapp-01a.corp.local',
    }

    response = requests.request("GET", url, headers=headers, verify=False)

    id = response.json()['results'][0]['id']

    urlDelete = url + id + "cascade=true"

    response2 = requests.request("DELETE", urlDelete, headers=headers, verify=False)
    
    return response2
