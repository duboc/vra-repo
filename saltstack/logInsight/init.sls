download_log_agent:
  cmd.run:
    - name: wget --no-check-certificate http://10.161.146.103/api/v1/agent/packages/types/deb -O /tmp/li-agent.deb
    - creates: /tmp/li-agent.deb
    
install_log_agent:
  cmd.run:
    - name: dpkg -i /tmp/li-agent.deb
    - require:
      - download_log_agent

push_li_config:
  file.managed:
    - name: /var/lib/loginsight-agent/liagent.ini
    - source: salt://logInsight/conf/liagent.ini
    - template: jinja
    - require:
      - install_log_agent
    
running_li_service:
  service.running:
    - name: liagentd
    - enable: True
    - watch:
      - push_li_config
