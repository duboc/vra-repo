import pprint
import json

from sseapiclient.tornado import SyncClient
client = SyncClient.connect('https://localhost', 'root', 'salt', ssl_validate_cert=False)

'''
Returns the job id
'''

print("------ INFO ABOUT THE JOB ------\n")
pprint.pprint(client.api.cmd.route_cmd(
    job_uuid='5c5cc410-4f9f-11e6-88bc-080027a7289c', tgt_uuid='89db0f82-4f9f-11e6-88bc-080027a7289c').ret)