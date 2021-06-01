{% set vrops_ip = salt['pillar.get']('vrops_data:vrops_ip') %}
{% set username = salt['pillar.get']('vrops_data:username') %}
{% set password = salt['pillar.get']('vrops_data:password') %}

{% if grains['os_family'] == 'Windows' %}
  {% set download_file = 'C:\tmp\vROpsTelegraf.ps1' %}
  {% set download_source = 'salt://vmware/vrops/scripts/vROpsTelegraf.ps1' %}
{% else %}
  {% set download_file = '/tmp/vROpsTelegraf.sh' %}
  {% set download_source = 'salt://vmware/vrops/scripts/vROpsTelegraf.sh' %}
{% endif %}


install_unzip:
  pkg.installed:
    - name: unzip

copy_vrops_script:
  file.managed:
    - name: {{ download_file }}
    - source: {{ download_source }}
    - mode: 0755

download_vrops_agent:
  cmd.run:
    - name: {{ download_file }}
    - require:
      - pkg: install_unzip

install_vrops_agent:
  cmd.run:
    - name: /tmp/download.sh  -o install -v {{ vrops_ip }} -u {{ username }} -p {{ password }} 


