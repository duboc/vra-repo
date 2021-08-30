# This state will create the roster file needed for salt-ssh.

{% from "docker/maps/prereq.yaml" import prereq with context %}
{% from "docker/maps/targets.yaml" import targetlist with context %}

{% for target in targetlist.targets %}
{% set target_info = targetlist.targets[target] %}
append_new_system{{target}}:
  file.append:
    - name: /etc/salt/roster
    - source: salt://docker/files/append_roster
    - template: jinja
    - context:
        use_ssh_key: {{target_info.use_ssh_key}}
        host: {{target_info.ip}}
        id: {{target}}

send_complete{{target}}:
  event.send:
    - name: custom/docker/roster-complete
    - data:
        status: roster created
        next_target: {{target}}
    - require:
      - file: append_new_system{{target}}

{% endfor %}
