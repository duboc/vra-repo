# declare jinja variables

{% set root_pw = salt['pillar.get']('root_pw', False) %}
{% set repluser_pw = salt['pillar.get']('repluser_password', False) %}

# install python mysql

install_python_mysgl:
  pkg.installed:
    - name: MySQL-python

# install mariadb-server

install_mariadb_server:
  pkg.installed:
    - name: mariadb-server

# stop mariadb service

stop_mariadb_service:
  module.run:
    - name: service.stop
    - m_name: mariadb
    - require:
      - pkg: install_mariadb_server

# make sure folders exists

check_mariadb_folders:
  file.directory:
    - names:
      - /data1/var/log/mariadb
      - /data1/var/lib/mariadb
      - /data1/var/run/mariadb
    - group: root
    - user: root
    - makedirs: True
    - recurse:
      - user
      - group


# start mariadb service

check_mariadb_service:
  service.running:
    - name: mariadb
    - enable: True
    - require:
      - file: check_mariadb_folders

# set root password (will be pillar)

set_root_password:
  module.run:
    - name: mysql.user_chpass
    - user: root
    - host: localhost
    - password: {{root_pw}}
    - require:
      - service: check_mariadb_service

# remove test database

remove_test_db:
  mysql_database.absent:
    - name: test
    - host: localhost
    - connection_user: root
    - connection_pass: {{root_pw}}

# setup replication user

create_replication_user:
  mysql_user.present:
    - name: replication_user
    - password: {{repluser_pw}}
    - host: '%'
    - connection_user: root
    - connection_pass: {{root_pw}}

grant_replication_user:
  mysql_grants.present:
    - grant: REPLICATION SLAVE
    - database: '*.*'
    - user: replication_user
    - host: '%'
    - connection_user: root
    - connection_pass: {{root_pw}}

update_minion_conf:
  file.append:
    - name: /etc/salt/minion.d/minion.conf
    - text: |
        mysql.host: 'localhost'
        mysql.user: 'root'
        mysql.pass: '{{root_pw}}'

        mine_functions:
          mysql.get_master_status: []

restart_minion:
  module.run:
    - name: service.restart
    - m_name: salt-minion
