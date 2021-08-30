import pprint
import json

from sseapiclient.tornado import SyncClient
client = SyncClient.connect('https://localhost', 'root', 'salt', ssl_validate_cert=False)

pprint.pprint(client.api.sec.get_checks(
    benchmark_uuids=["5ae41b9e-eb9e-4f24-b146-21d868f95195"]
).ret[uuid])
