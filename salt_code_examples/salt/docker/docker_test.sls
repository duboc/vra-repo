{% set docker_info = salt['dockerng.info'] %}

test_info:
  test.configurable_test_state:
    - name: dockerinfotest
    - changes: False
    - result: False
    - comment: returned values: {{docker_info}}
