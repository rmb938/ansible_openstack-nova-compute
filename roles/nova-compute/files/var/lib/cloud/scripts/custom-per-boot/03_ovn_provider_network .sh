#!/bin/bash

set -exuo pipefail

teng_nic=""
teng_nic_num=2
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

# Make sure link is up
ip link set ${teng_nic} up

# Create provider br if DNE
ovs-vsctl --may-exist add-br br-provider -- set bridge br-provider protocols=OpenFlow13

# Setup provider mapping
ovs-vsctl set open . external-ids:ovn-bridge-mappings=provider:br-provider

# Add 2nd 10G nic to provider bridge if DNE
ovs-vsctl --may-exist add-port br-provider ${teng_nic}
