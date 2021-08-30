# declare jinja variables

{% set root_pw = salt['pillar.get']('root_pw', False) %}
{% set cmuser_password = salt['pillar.get']('cmuser_password', False) %}
{% set amonuser_password = salt['pillar.get']('amonuser_password', False) %}
{% set rmanuser_password = salt['pillar.get']('rmanuser_password', False) %}
{% set hiveuser_password = salt['pillar.get']('hiveuser_password', False) %}
{% set sentryuser_password = salt['pillar.get']('sentryuser_password', False) %}
{% set navuser_password = salt['pillar.get']('navuser_password', False) %}
{% set navmsuser_password = salt['pillar.get']('navmsuser_password', False) %}
{% set oozieuser_password = salt['pillar.get']('oozieuser_password', False) %}
{% set hueuser_password = salt['pillar.get']('hueuser_password', False) %}
{% set sqoopuser_password = salt['pillar.get']('sqoopuser_password', False) %}
# create the cloudera databases and users

create_cmuser_user:
  mysql_user.present:
    - name: cmuser
    - password: {{cmuser_password}}
    - host: '%'

create_scm_db:
  mysql_database.present:
    - name: scm
    - host: localhost

grant_scm:
  mysql_grants.present:
    - grant: all privileges
    - database: scm.*
    - user: cmuser
    - host: '%'

create_hive_user:
    mysql_user.present:
      - name: hiveuser
      - password: {{hiveuser_password}}
      - host: '%'

create_metastore_db:
  mysql_database.present:
    - name: metastore
    - host: localhost

grant_hive:
  mysql_grants.present:
    - grant: all privileges
    - database: metastore.*
    - user: hiveuser
    - host: '%'

create_amon_user:
  mysql_user.present:
    - name: amonuser
    - password: {{amonuser_password}}
    - host: '%'

create_amon_db:
  mysql_database.present:
    - name: amon
    - host: localhost

grant_amon:
  mysql_grants.present:
    - grant: all privileges
    - database: amon.*
    - user: amonuser
    - host: '%'

create_rman_user:
  mysql_user.present:
    - name: rmanuser
    - password: {{rmanuser_password}}
    - host: '%'

create_rman_db:
  mysql_database.present:
    - name: rman
    - host: localhost

grant_rman:
  mysql_grants.present:
    - grant: all privileges
    - database: rman.*
    - user: rmanuser
    - host: '%'

create_oozie_user:
  mysql_user.present:
    - name: oozieuser
    - password: {{oozieuser_password}}
    - host: '%'

create_oozie_db:
  mysql_database.present:
    - name: oozie
    - host: localhost

grant_oozie:
  mysql_grants.present:
    - grant: all privileges
    - database: oozie.*
    - user: oozieuser
    - host: '%'

create_hue_user:
  mysql_user.present:
    - name: hueuser
    - password: {{hueuser_password}}
    - host: '%'

create_hue_db:
  mysql_database.present:
    - name: hue
    - host: localhost

grant_hue:
  mysql_grants.present:
    - grant: all privileges
    - database: hue.*
    - user: hueeuser
    - host: '%'

create_sentry_user:
  mysql_user.present:
    - name: sentryuser
    - password: {{sentryuser_password}}
    - host: '%'

create_sentry_db:
  mysql_database.present:
    - name: sentry
    - host: localhost

grant_sentry:
  mysql_grants.present:
    - grant: all privileges
    - database: sentry.*
    - user: sentryuser
    - host: '%'

create_nav_user:
  mysql_user.present:
    - name: navuser
    - password: {{navuser_password}}
    - host: '%'

create_nav_db:
  mysql_database.present:
    - name: nav
    - host: localhost

grant_nav:
  mysql_grants.present:
    - grant: all privileges
    - database: nav.*
    - user: navuser
    - host: '%'

create_navms_user:
  mysql_user.present:
    - name: navmsuser
    - password: {{navmsuser_password}}
    - host: '%'

create_navms_db:
  mysql_database.present:
    - name: navms
    - host: localhost

grant_navms:
  mysql_grants.present:
    - grant: all privileges
    - database: navms.*
    - user: navmsuser
    - host: '%'

create_sqoop_user:
  mysql_user.present:
    - name: sqoopuser
    - password: {{sqoopuser_password}}
    - host: '%'

create_sqoop_db:
  mysql_database.present:
    - name: sqoop
    - host: localhost

grant_sqoop:
  mysql_grants.present:
    - grant: all privileges
    - database: sqoop.*
    - user: sqoopuser
    - host: '%'
