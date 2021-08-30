#calls the docker config state

run_docker_config:
  local.state.apply:
    - tgt: {{ data['data']['next_target'] }}
    - arg:
      - docker.docker_config
