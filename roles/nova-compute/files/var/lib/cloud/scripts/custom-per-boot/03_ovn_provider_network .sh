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

if [[ -z "$teng_nic" ]]; then
  echo "Did not find nic by looking for 10g, maybe we are in a proxmox vm"
  mac_prefix="bc:24:11"

  # Reset vars
  teng_nic=""
  teng_nic_num=2

  for nic in $(ls /sys/class/net); do

    mac_file="/sys/class/net/$nic/address"

     # Read the MAC address from the file
    mac_address=$(cat "$mac_file")

    # Check if the MAC address starts with the specified prefix
    # Using substring comparison
    if [[ "${mac_address:0:${#mac_prefix}}" == "$mac_prefix" ]]; then
      teng_nic_num=$((teng_nic_num - 1))
      if [ "$teng_nic_num" -eq 0 ]; then
        teng_nic="$nic"
        break
      fi
    fi
  done
fi

# Make sure link is up
ip link set ${teng_nic} up

# Create provider br if DNE
ovs-vsctl --may-exist add-br br-provider -- set bridge br-provider protocols=OpenFlow13

# Setup provider mapping
ovs-vsctl set open . external-ids:ovn-bridge-mappings=provider:br-provider

# Add 2nd 10G nic to provider bridge if DNE
ovs-vsctl --may-exist add-port br-provider ${teng_nic}
