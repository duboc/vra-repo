{% set target = salt.pillar.get('target') %}
{% from "docker/maps/prereq.yaml" import prereq with context %}

accept_ssh_keys:
  salt.function:
    - name: cmd.run
    - tgt: {{prereq.master_minion}}
    - arg:
      - salt-ssh {{ target }} -i test.ping

run_check_internet_state:
  salt.state:
    - tgt: {{target}}
    - ssh: True
    - sls:
      - docker.check_internet

send_internet_ok_event:
  salt.state:
    - tgt: {{prereq.master_minion}}
    - sls:
      - docker.eventstates.internet_succes
    - pillar:
        target: {{target}}
    - require:
      - salt: run_check_internet_state
