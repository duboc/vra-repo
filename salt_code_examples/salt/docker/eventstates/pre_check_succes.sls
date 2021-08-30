# send the precheck succes event
{% set target = salt.pillar.get('target') %}

send_complete_precheck:
  event.send:
    - name: custom/docker/prereq-complete
    - data:
        status: prereq completed
        next_target: {{target}}
