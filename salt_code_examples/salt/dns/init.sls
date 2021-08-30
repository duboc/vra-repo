{% load_yaml as osmap %}
Debian:
  pkg: bind9
  srv: bind9
RedHat:
  pkg: bind
  srv: named
{% endload %}
# Filter dictionary by os_family grain and merge pillar
{% set dns = salt['grains.filter_by'](osmap, merge=salt['pillar.get']('dns:lookup')) %}

setup_dns:
  pkg.installed:
    - name: {{dns.pkg}}

check_service:
  service.running:
    - name: {{dns.srv}}

create_user:
  user.present:
    - name: {{dns.user}}
    - password: {{dns.password}}

create_group:
  group.present:
    - name: {{ dns.group}