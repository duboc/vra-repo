import json
import requests

def handler(context, inputs):

    def get_auth_token():
        url = "https://api.mgmt.cloud.vmware.com/iaas/api/login"
        payload = "{\n    \"refreshToken\": \"your-refresh-token\"\n}"
        headers = { 'Content-Type': 'application/json', 'Host': 'api.mgmt.cloud.vmware.com'}
        authentication  = requests.request("POST", url, headers=headers, data=payload)
        bearerToken = authentication.json()['token']
        return bearerToken
    
    def get_resource_name_byid(token, deployId):
        '''
        fetch an resource details by id
        '''
        url = f"https://api.mgmt.cloud.vmware.com/deployment/api/deployments/{deployId}/resources"
        payload = {}
        headers = {'Authorization': f'Bearer {token}'}
        response = requests.get(url, headers=headers, data=payload)
        return response
    
    def get_ls_id_by_name(logicalSwitchName):
        url = "https://192.168.110.31/api/v1/logical-switches"
        headers = {
          'Authorization': 'Basic YWRtaW46Vk13YXJlMSFWTXdhcmUxIQ==',
          'Host': 'nsx-1.corp.local',
        }
        
        name = logicalSwitchName
        response = requests.request("GET", url, headers=headers, verify=False)
        ids = [ i["id"] for i in response.json()["results"] if i["display_name"] == name ]

        return ids

    def get_bridge_endpoints():
        url = "https://192.168.110.31/api/v1/bridge-endpoints"

        payload = {
           "resource_type": "BRIDGEENDPOINT",
           "vlan_transport_zone_id": "79ac96ba-a69e-4df5-9f8e-557bc085c4eb",
           "bridge_endpoint_profile_id": "c0002a37-4a45-43b3-afe6-635a3d2cac39",
           "vlan": "3009",
        }

        headers = {
           'Content-Type': 'application/json',
           'Authorization': 'Basic YWRtaW46Vk13YXJlMSFWTXdhcmUxIQ==',
        }
        
        response = requests.request("POST", url, headers=headers, json=payload, verify=False)
        response.raise_for_status()
        return response.json()
    
    def create_logical_ports(id, nameSwitch):
        url = "https://192.168.110.31/api/v1/logical-ports"
        payload = {
            "logical_switch_id": nameSwitch,
            "admin_state": "UP",
            "attachment": {
              "id": id,
              "attachment_type": "BRIDGEENDPOINT"
            },
        }

        headers = {
              'Content-Type': 'application/json',
              'Authorization': 'Basic YWRtaW46Vk13YXJlMSFWTXdhcmUxIQ=='
        }

        response = requests.request("POST", url, headers=headers, json=payload, verify=False)
        response.raise_for_status()
        return response.json()
    
    
    token = get_auth_token()
    deployId = inputs['deploymentId']
    
    resourceName = get_resource_name_byid(token, deployId)
    
    logicalSwitchName = str(resourceName.json()['content'][0]['properties']['resourceName'])
    
    print(logicalSwitchName)

    lsId = get_ls_id_by_name(logicalSwitchName)
    print(lsId)
    print(lsId[0])
    
    nameSwitch = lsId[0]
    print(nameSwitch)
    bridge_endpoints = get_bridge_endpoints()

    createBridge = create_logical_ports(bridge_endpoints["id"], nameSwitch)

    print(createBridge)