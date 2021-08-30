from sseapiclient.tornado import SyncClient
host = 'https://192.168.50.11'
user = 'root'
password = 'salt'
client = SyncClient.connect(host, user, password, ssl_validate_cert=False)
client.api.admin.trim_database(
    audit=5, events=5, jobs=5, schedule=5, test=False)
