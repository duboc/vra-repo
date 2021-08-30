import pprint
import json

from sseapiclient.tornado import SyncClient
client = SyncClient.connect('https://localhost', 'root', 'salt', ssl_validate_cert=False)


print("------ INFO ABOUT ALL TARGETS ------\n")
pprint.pprint(client.api.tgt.get_target_group().ret)

