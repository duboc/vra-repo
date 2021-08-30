from sseapiclient.tornado import SyncClient
client = SyncClient.connect('https://localhost', 'root', 'salt', ssl_validate_cert=False)

client.api.cmd.route_cmd(cmd='runner',
                         fun='state.orch',
                         masters='salt', # cluster ID
                         arg={'arg': ["myorch"], # orchestration state
                              'kwarg': {
                                  "pillar": {    # inline pillar data
                                      "targets":"minion1",
                                      "foo":"bar",
                                      "fruit":"apples"
                                  }
