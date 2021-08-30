# this state will check for internet access

{% set id = salt['grains.get']('id') %}

check_internet_access:
  firewall.check:
    - name: 'google.com'
    - port: 80
    - proto: 'tcp'

no_internet:
  event.send:
    - name: custom/docker/internet-check-failed
    - data:
        status: no internet
        failed_system: {{id}}
    - onfail:
      - firewall: check_internet_access

stop_state:
  test.configurable_test_state:
    - name: State execution halted
    - changes: False
    - result: False
    - comment: internet check failed, state execution halted.
    - onfail:
      - firewall: check_internet_access
