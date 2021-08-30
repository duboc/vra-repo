# configure docker.

{% from "docker/maps/targets.yaml" import targetlist with context %}
{% from "docker/maps/prereq.yaml" import prereq with context %}
{% set id = salt['grains.get']('id') %}
{% set targetinfo = targetlist.targets[id] %}
{% set target_ip = targetinfo.ip %}
{% set interface_name = salt['network.ifacestartswith'](target_ip)[0] %}

{% set subnetcidr = salt['network.subnets'](interface_name)[0] %}
{% set routeinfo = salt['network.default_route']("inet") %}
{% set gateway= routeinfo[0]['gateway'] %}


# get docker values

{% set IPRangeCIDR = targetinfo.dockerinfo.IPRangeCIDR %}
{% set macvlanname = targetinfo.dockerinfo.macvlanname %}
{% set excludedIP = targetinfo.dockerinfo.excludedIP %}
{% set dockerurl = prereq.vosflex.dockerurl %}
{% set dockerpath = prereq.vosflex.dockerpath %}
{% set tag = prereq.vosflex.tag %}
{% set account = salt['pillar.get']('docker_account').account %}
{% set password = salt['pillar.get']('docker_account').password %}

# check if configured allready

{% set allready_installed = salt['grains.get']('vosflex_installed', False) %}


{% if allready_installed == False %}

# create docker network

create_docker_network:
  cmd.run:
    - name: docker network create -d macvlan --subnet={{subnetcidr}} --gateway={{gateway}} --aux-address="exclude_host={{excludedIP}}" --ip-range={{IPRangeCIDR}} -o parent={{interface_name}} {{macvlanname}}

# login into docker

log_into_docker:
  cmd.run:
    - name: docker login -u {{account}} -p {{password}} {{dockerurl}}

# pull docker image

pull_docker_image:
  cmd.run:
    - name: docker pull {{dockerpath}}/{{tag}}

# run the docker image

run_the_docker_image:
  cmd.run:
    - name: docker run -d --privileged --net={{macvlanname}} {{dockerpath}}/{{tag}}

#send complete event

docker_config_complete:
  event.send:
    - name: custom/harmonic/docker-configured
    - data:
        status: docker configured
        next_target: {{id}}
    - require:
      - cmd: run_the_docker_image

# send the vosflex_installed grain.

set_vosflex_installed_grain:
  grains.present:
    - name: vosflex_installed
    - value: True
    - require:
      - event: docker_config_complete

{% else %}

# gracefull state execution end

docker_allready_configured:
  test.configurable_test_state:
    - name: vosflex_installed
    - changes: False
    - result: True
    - comment: voslfex allready installed

{% endif %}
