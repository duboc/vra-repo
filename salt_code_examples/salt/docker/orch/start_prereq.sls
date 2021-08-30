{% set target = salt.pillar.get('target') %}
{% from "docker/maps/prereq.yaml" import prereq with context %}

run_prereq_state:
  salt.state:
    - tgt: {{target}}
    - ssh: True
    - sls:
      - docker.check_prereq

# if successful update the pillar data for minion.
run_pillar_sync:
  salt.function:
    - name: cmd.run
    - tgt: {{prereq.master_minion}}
    - arg:
      - salt {{ target }} saltutil.sync_all
    - require:
      - salt: run_prereq_state

send_complete_precheck_event:
  salt.state:
    - tgt: {{prereq.master_minion}}
    - sls:
      - docker.eventstates.pre_check_succes
    - pillar:
        target: {{target}}
    - require:
      - salt: run_prereq_state
