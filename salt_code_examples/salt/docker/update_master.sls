# update the master.d folder with a reactor.conf file.

update_reactor_config:
  file.managed:
    - name: /etc/salt/master.d/reactor.conf
    - source: salt://docker/files/reactor.conf
    - makedirs: True

restart_master:
  service.running:
    - name: salt-master
    - watch:
      - file: update_reactor_config
