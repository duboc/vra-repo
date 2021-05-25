install_unzip:
  pkg.installed:
    - name: unzip

copy_vrops_script:
  file.managed:
    - name: /tmp/vROpsTelegraf.sh
    - source: salt://vrops/agent/scripts/vROpsTelegraf.sh
    - mode: 0755

download_vrops_agent:
  cmd.run:
    - name: /tmp/vROpsTelegraf.sh
    - require:
      - pkg: install_unzip

install_vrops_agent:
  cmd.run:
    - name: /tmp/download.sh  -o install -v 10.182.14.128 -u admin -p VMware1\!

