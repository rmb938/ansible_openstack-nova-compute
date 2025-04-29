#!/bin/bash

set -exuo pipefail

# Wait for the OVS DB to start
set +e
while ! ovs-vsctl show; do
  sleep 1
done
set -e

ovs-vsctl set open . external-ids:hostname="$(hostname -f)" external_ids:system-id="$(cat /sys/class/dmi/id/product_uuid)"
