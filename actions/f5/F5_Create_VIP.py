import f5.bigip
from f5.bigip import ManagementRoot

def handler(context,inputs):
    mgmt = ManagementRoot("192.168.110.171", "admin", "vmware1!vmware1!")
    virtuals = mgmt.tm.ltm.virtuals.get_collection()
  
    virtualIpName = inputs['requestInputs']['vipName']
    
    poolName = inputs['requestInputs']['nomeDoPool']
    
    enderecoVip = inputs['requestInputs']['vipAddress']
    
    
    mgmt.tm.ltm.virtuals.virtual.create(name=virtualIpName, destination='{}:{}'.format(enderecoVip, str(80)), sourceAddressTranslation={'type': 'automap'}, pool=f'/Common/{poolName}')
 
