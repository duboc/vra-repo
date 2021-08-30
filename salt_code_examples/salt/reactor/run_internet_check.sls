# execute the internet check.

run_internet_check:
  runner.state.orchestrate:
    - mods: docker.orch.start_internet_check
    - pillar:
        target: {{data['data']['next_target']}}
