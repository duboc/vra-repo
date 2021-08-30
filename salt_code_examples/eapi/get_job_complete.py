import pprint
import json

from sseapiclient.tornado import SyncClient
client = SyncClient.connect('https://localhost', 'root', 'salt', ssl_validate_cert=False)

print("------ INFO ABOUT THE JOB Results ------\n")

pprint.pprint(client.api.cmd.get_cmds(jid='20200821154924768210').ret)
