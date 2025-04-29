#!/bin/bash

set -exuo pipefail

ovs-vsctl set open . external-ids:ovn-cms-options=enable-chassis-as-gw
