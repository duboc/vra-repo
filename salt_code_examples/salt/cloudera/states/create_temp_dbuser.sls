# this state will create a temp db user and grant all access
# the user is used to invoke the cloudera db setup script

{% set root_pw = salt['pillar.get']('root_pw', False) %}

create_temp_user:
  mysql_user.present:
    - name: temp
    - password: temp
    - host: '%'
    - connection_user: root
    - connection_pass: {{root_pw}}

grant_temp:
  mysql_grants.present:
    - grant: all privileges
    - database: '*.*'
    - user: temp
    - host: '%'
    - connection_user: root
    - connection_pass: {{root_pw}}
