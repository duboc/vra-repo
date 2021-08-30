# this will delete the temp dbuser used  during installation

{% set root_pw = salt['pillar.get']('root_pw', False) %}

delete_temp_dbuser:
  mysql_user.absent:
    - name: temp
    - host: '%'
    - connection_user: root
    - connection_pass: {{root_pw}}
