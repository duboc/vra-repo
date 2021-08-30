# ochestration state to deploy cloudera
# the targets and roles are defined in the maps/config.yaml file

{% import_yaml 'cloudera/maps/config.yaml' as data with context %}

# update pillar data

update_pillar_{{data.dbmaster}}:
  salt.function:
    - name: saltutil.refresh_pillar
    - tgt: {{data.dbmaster}}

update_pillar_{{data.dbslave}}:
  salt.function:
    - name: saltutil.refresh_pillar
    - tgt: {{data.dbslave}}

# deploy mariadb

deploy_mariadb_master:
  salt.state:
    - sls:
      - cloudera.states.install_master_db
    - tgt: {{data.dbmaster}}

# wait for masterdb minion

wait_for_dbmaster:
  salt.wait_for_event:
    - name: salt/auth
    - id_list:
      - {{data.dbmaster}}
    - timeout: 600

deploy_mariadb_slave:
  salt.state:
    - sls:
      - cloudera.states.install_slave_db
    - tgt: {{data.dbslave}}

# wait for slavedb minion

wait_for_dbslave:
  salt.wait_for_event:
    - name: salt/auth
    - id_list:
      - {{data.dbslave}}
    - timeout: 600
#prepare master db

update_cnf_on_masterdb:
  salt.state:
    - sls:
      - cloudera.states.repl_prepare_master
    - tgt: {{data.dbmaster}}

# configure replication

run_config_replication:
  salt.state:
    - sls:
      - cloudera.states.config_replication
    - tgt: {{data.dbslave}}
    - pillar:
        masterhost: {{data.dbmaster}}

# create the cloudera db's on masterdb

create_all_cloudera_db:
  salt.state:
    - sls:
      - cloudera.states.install_database
    - tgt: {{data.dbmaster}}

# deploy cloudera manager

deploy_cloudera_manager:
  salt.state:
    - sls:
      - cloudera.states.cloudera_pkgs
    - tgt: {{data.cloudera_manager}}
