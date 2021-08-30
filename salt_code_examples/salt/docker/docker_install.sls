# install Docker and update pillar top file

{% from "docker/maps/docker.yaml" import dockerinfo with context %}

{% set os = salt['grains.get']('os') %}
{% set id = salt['grains.get']('id') %}

{% if os == "CentOS" %}

# add repo and set package name
{% for repo in dockerinfo.docker_repos %}
{% set repoinfo = dockerinfo.docker_repos[repo] %}
add_docker_repo{{repo}}:
  pkgrepo.managed:
    - name: {{repo}}
    - humanname: {{repoinfo.humanname}}
    - baseurl: {{repoinfo.baseurl}}
    - gpgkey: {{repoinfo.gpgkey}}
    - enabled: True
    - gpgcheck: 1
{% endfor %}

{% set dockerpkg = "docker-ce" %}

{% elif os == "Ubuntu" %}

{% set dockerpkg = "docker.io" %}

{% endif %}

install_docker:
  pkg.installed:
    - name: {{dockerpkg}}

start_docker_service:
  service.running:
    - name: docker
    - enable: True
    - require:
      - pkg: install_docker


# send events of success of failed

send_succes_event:
  event.send:
    - name: custom/docker/docker-installed
    - data:
        status: docker installed
        next_target: {{id}}
    - require:
      - pkg: install_docker
      - service: start_docker_service

send_failed_event:
  event.send:
    - name: custom/docker/docker-install-failed
    - data:
        status: docker install failed
    - onfail:
      - pkg: install_docker
