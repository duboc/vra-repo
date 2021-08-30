import pprint
import json

from sseapiclient.tornado import SyncClient
client = SyncClient.connect('https://localhost', 'root', 'salt', ssl_validate_cert=False)

ret=client.api.job.save_job(name='deploy lab instances - eAPI',
  desc='Cloud runner job created via eAPI',
  cmd='runner',
  masters=['salt'],
  fun='cloud.map_run',
  arg={'arg': ["/etc/salt/cloud.maps.d/my_instances.map","parallel=True"] }
  )

print "Job Cloud runner job created via eAPI created: " + json.dumps(ret.ret)
