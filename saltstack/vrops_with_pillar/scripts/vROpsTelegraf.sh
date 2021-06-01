#!/bin/bash

{% set cp_ip = salt['pillar.get']('vrops_data:cloud_proxy_ip') %}

ip={{ cp_ip }}

wget --no-check-certificate https://$ip/downloads/salt/download.sh
chmod +x download.sh

mv download.sh /tmp/download.sh
