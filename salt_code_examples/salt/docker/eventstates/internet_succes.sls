# send the internet success event

{% set target = salt.pillar.get('target') %}

internet_ok:
  event.send:
    - name: custom/docker/internet-check-complete
    - data:
        status: internet success
        next_target: {{target}}
