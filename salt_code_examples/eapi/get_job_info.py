import pprint
import json

from sseapiclient.tornado import SyncClient
client = SyncClient.connect('https://localhost', 'root', 'salt', ssl_validate_cert=False)

print("------ INFO ABOUT THE JOB Results ------\n")

pprint.pprint(client.api.ret.get_returns(jid='20190116150137215882').ret)