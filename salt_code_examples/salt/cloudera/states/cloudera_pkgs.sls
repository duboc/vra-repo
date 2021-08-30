
{% import_yaml 'cloudera/maps/config.yaml' as data with context %}
{% set scm_installed = salt['grains.get']('scm_installed', False) %}

# create the repo

cloudera_repo:
  pkgrepo.managed:
    - name: cloudera-manager
    - humanname: Cloudera Manager
    - baseurl: https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/5/
    - keyurl: https://archive.cloudera.com/cm5/redhat/7/x86_64/cm/RPM-GPG-KEY-cloudera
    - gpgcheck: 1
    - enabled: True
    - refresh_db: True

# install java

install_java:
  pkg.installed:
    - name: oracle-j2sdk1.7
    - skip_verify: True
    - fromrepo: cloudera-manager
    - require:
      - pkgrepo: cloudera_repo

# install cloudera manager

install_cloudera_manager:
  pkg.installed:
    - pkgs:
      - cloudera-manager-daemons
      - cloudera-manager-server
    - fromrepo: cloudera-manager
    - skip_verify: True

# update cloudera-scm-server

update_cloudera_scm_server:
  file.append:
    - name: /etc/default/cloudera-scm-server
    - text: export JAVA_HOME=/usr/java/jdk1.7.0_67-cloudera

# install mysql connector

extract_mysql_connector:
  archive.extracted:
    - name: /temp/sql_connector
    - source: salt://cloudera/states/files/mysql-connector-java-5.1.45.tar.gz

copy_jar_file:
  file.copy:
    - name: /usr/share/java/mysql-connector-java.jar
    - source: /temp/sql_connector/mysql-connector-java-5.1.45/mysql-connector-java-5.1.45-bin.jar
    - makedirs: True

check_cloudera_service:
  service.running:
    - name: cloudera-scm-server
    - enable: True
