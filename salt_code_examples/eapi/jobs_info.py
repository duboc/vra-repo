import pprint
import json

from sseapiclient.tornado import SyncClient
client = SyncClient.connect('https://localhost', 'root', 'salt', ssl_validate_cert=False)


print("------ INFO ABOUT ALL JOBS ------\n")
pprint.pprint(client.api.job.get_jobs().ret)


print("\n")
print("\n")
raw_input("Press Enter to continue...")
print("------ INFO ABOUT MY JOB ------\n")
myjob = client.api.job.get_jobs(job_uuid='e4984d80-6a80-11e6-b990-080027a7289c').ret
print("JOB NAME: " + myjob['name'])
print json.dumps(myjob, indent=4)
