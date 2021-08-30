# declare jinja variables

{% set root_pw = salt['pillar.get']('root_pw', False) %}

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

check_mariadb_folders:
  file.directory:
    - names:
      - /data1/var/log/mariadb
      - /data1/var/lib/mariadb
      - /data1/var/run/mariadb
    - group: mysql
    - user: mysql
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

update_minion_conf:
  file.append:
    - name: /etc/salt/minion.d/minion.conf
    - text: |
        mysql.host: 'localhost'
        mysql.user: 'root'
        mysql.pass: '{{root_pw}}'

restart_minion:
  module.run:
    - name: service.restart
    - m_name: salt-minion
