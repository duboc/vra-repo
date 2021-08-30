# calls the docker_install state

run_docker_install:
  local.state.apply:
    - tgt: {{ data['data']['next_target'] }}
    - arg:
      - docker.docker_install
