# this reactor will execute the start_prereq orch state.

run_prereq_orch:
  runner.state.orchestrate:
    - mods: docker.orch.start_prereq
    - pillar:
        target: {{data['data']['next_target']}}
