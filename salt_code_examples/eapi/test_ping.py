import pprint
import json

from sseapiclient.tornado import SyncClient
client = SyncClient.connect('https://localhost', 'root', 'salt', ssl_validate_cert=False)

'''
Returns the job id
'''

print("------ INFO ABOUT THE JOB ------\n")
pprint.pprint(client.api.cmd.route_cmd(
    cmd='local',
    fun='test.ping',
    tgt={'salt': {'tgt': '*', 'tgt_type': 'glob'}}).ret)
