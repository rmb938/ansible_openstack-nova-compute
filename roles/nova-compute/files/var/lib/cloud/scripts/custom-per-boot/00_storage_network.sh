#!/bin/bash

set -exuo pipefail

default_nic=$(ip route | grep default | awk '{print $5}')
host_octal=$(ip -o -4 addr show ${default_nic} | awk '{print $4}' | rev | cut -d'.' -f1 | rev)

storage_nic=""
set +e
for nic in $(ls /sys/class/net); do
  ethtool "$nic" | grep "50000baseKR2/Full"
  if [[ $? -eq 0 ]]; then
    storage_nic="$nic"
    break
  fi
done
set -e

ip addr add 192.168.27.${host_octal} dev ${storage_nic}
ip link set ${storage_nic} up
