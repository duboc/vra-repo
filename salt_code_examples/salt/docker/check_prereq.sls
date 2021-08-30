# Check prerequisite's, if True install minion.

{% from "docker/maps/prereq.yaml" import prereq with context %}

{% set id = salt['grains.get']('id') %}
{% set diskinfo = salt['disk.usage']() %}
{% set root_info = diskinfo["/"] %}
{% set nr_cpu = salt['grains.get']('num_cpus') %}
{% set ram = salt['grains.get']('mem_total') %}
{% set core_type = salt['grains.get']('cpu_model') %}


{% if (root_info.available >= prereq.resource_minimums.mindisk) and
(nr_cpu >= prereq.resource_minimums.mincpu) and (ram >= prereq.resource_minimums.minram) and
(core_type in prereq.resource_minimums.coretypes) %}

install_minion:
  pkg.installed:
    - name: salt-minion

update_minion_conf:
  file.managed:
    - name: /etc/salt/minion.d/minion.conf
    - source: salt://docker/files/minion.conf
    - makedirs: True
    - template: jinja
    - context:
        master: {{prereq.master}}
        id: {{id}}
    - require:
      - pkg: install_minion

start_minion:
  service.running:
    - name: salt-minion
    - enable: True
    - watch:
      - file: update_minion_conf
    - require:
      - pkg: install_minion

{% else %}

send_failed_precheck:
  event.send:
    - name: custom/docker/prereq-failed
    - data:
        status: prereq failed
        disk_info: {{root_info.available}}
        cpu_info: {{nr_cpu}}
        ram_info: {{ram}}
        cpu_type: {{core_type}}

stop_state:
  test.configurable_test_state:
    - name: State execution halted
    - changes: False
    - result: False
    - comment: Prereq check failed, state execution halted.

{% endif %}
