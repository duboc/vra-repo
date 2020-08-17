import f5.bigip
from f5.bigip import ManagementRoot

def handler(context,inputs):
    mgmt = ManagementRoot("192.168.110.171", "admin", "vmware1!vmware1!")
    
    poolName = inputs['customProperties']['nomeDoPool']
    servico = inputs['customProperties']['portaServico']
    print(poolName)
    
    pool_obj = mgmt.tm.ltm.pools.pool
    
    poolAtual = pool_obj.load(partition='Common', name=poolName)
    print(poolAtual)

    members = poolAtual.members_s
    member = poolAtual.members_s.members
    
    ip = inputs['addresses'][0][0] + ":" + str(servico) 
    
    m1 = poolAtual.members_s.members.create(partition='Common', name=ip)
    
    m1 = poolAtual.members_s.members.load(partition='Common', name=ip)