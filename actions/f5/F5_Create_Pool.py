import f5.bigip
from f5.bigip import ManagementRoot

def handler(context,inputs):
    mgmt = ManagementRoot("192.168.110.171", "admin", "vmware1!vmware1!")
    
    # capturar nome do pool escrita no form
    nomePool = inputs['requestInputs']['nomeDoPool']
    
    # capturar metodo de modoBalanceamento
    modoBalanceamento = inputs['requestInputs']['algoritmoLb']
    
    # capturando a descricao do pool inserida no form
    descricaoPool = inputs['requestInputs']['poolDescription']
    
    
    # criar pool 
    virtualPool = mgmt.tm.ltm.pools.pool.create(name=nomePool, partition='Common')
    
    virtualPool.description = descricaoPool
    virtualPool.loadBalancingMode = modoBalanceamento
    virtualPool.update()
