# update my.cnf with master

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
        server_id=1
        log-basename=master1

check_mariadb_masterservice:
  service.running:
    - name: mariadb
