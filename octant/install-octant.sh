#!/bin/bash

# Unsupported 
# Install octant on vRA appliance

wget https://github.com/vmware-tanzu/octant/releases/download/v0.10.2/octant_0.10.2_Linux-64bit.rpm

rpm -i octant_0.10.2_Linux-64bit.rpm

kubectl config view --minify --flatten > kube-config

iptables -I INPUT -s 0.0.0.0/0 -j ACCEPT

octant --kubeconfig kube-config  --listener-addr 0.0.0.0:7777 --disable-open-browser  &
