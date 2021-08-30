{% set masterhost = salt['pillar.get']('masterhost', False) %}

{% set repluser_password = salt['pillar.get']('repluser_password', False) %}

{%- set master_status = salt['mine.get'](masterhost, 'mysql.get_master_status').get(masterhost, {}) %}

{%- set setup_replication_query = "CHANGE MASTER TO MASTER_HOST='"+masterhost+"', MASTER_USER='replication_user', MASTER_PASSWORD='"+repluser_password+"', MASTER_LOG_FILE='"+master_status.get('File', 'master1-bin.000001')+"', MASTER_SSL=0, MASTER_LOG_POS="+master_status.get('Position', '1')|string+"; START SLAVE;" %}



stop_mariadb_masterservice:
  module.run:
    - name: service.stop
    - m_name: mariadb

update_master_cnf:
  file.append:
    - name: /etc/my.cnf
    - text: |
        [mariadb]
        log-bin
        server_id=101
        log-basename=slave101

check_mariadb_masterservice:
  service.running:
    - name: mariadb



start_replication:
  module.run:
    - name: mysql.query
    - database: mysql
    - query: {{setup_replication_query}}
