#!/bin/bash

set -exuo pipefail

default_nic=$(ip route | grep default | awk '{print $5}')
host_octal=$(ip -o -4 addr show ${default_nic}  | awk '{print $4}' | rev | cut -d'.' -f1 | rev)

teng_nic=""
teng_nic_num=1
set +e
for nic in $(ls /sys/class/net); do
  ethtool "$nic" | grep "10000baseT/Full"
  if [[ $? -eq 0 ]]; then
    teng_nic_num=$((teng_nic_num - 1))
    if [ "$teng_nic_num" -eq 0 ]; then
      teng_nic="$nic"
      break
    fi
  fi
done
set -e

# Set IP
ip addr add 192.168.28.${host_octal} dev ${teng_nic}
ip link set ${teng_nic} up

# Set encap type
ovs-vsctl set open . external-ids:ovn-encap-type=geneve

# Set encap IP
ovs-vsctl set open . external-ids:ovn-encap-ip=192.168.28.${host_octal::-3}

# Set Manager
set +e
ovs-vsctl --id @manager create Manager "target=ptcp\:6640\:127.0.0.1" -- add Open_vSwitch . manager_options @manager || true
set -e
