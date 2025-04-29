#!/bin/bash

set -exuo pipefail

mount.nfs 192.168.27.40:/mnt/tank-ssd/vms/instances /var/lib/nova/instances -o sync,noacl,noatime,nodiratime,noac,vers=4.2