# {{ ansible_managed }}

vault {
  address = "http://127.0.0.1:8100"
  renew_token = false
  retry {
    # Settings to 0 for unlimited retries.
    attempts = 0
  }
}

consul {
  address = "127.0.0.1:8500"
  retry {
    # Settings to 0 for unlimited retries.
    attempts = 0
  }
}

wait {
  min = "15s"
  max = "30s"
}

# OVN NB OVSDB CA
template {
  source = "/etc/consul-template/templates/neutron/ovn-nb-ovsdb-ca.crt.ctmpl"
  destination = "/etc/neutron/ovn-nb-ovsdb-ca.crt"
  create_dest_dirs = false
  perms = "0644"
  exec {
    command = "sudo systemctl reload-or-restart neutron-ovn-metadata-agent || true"
  }
}

# OVN NB OVSDB User
template {
  source = "/etc/consul-template/templates/neutron/ovn-nb-ovsdb-user-neutron.ctmpl"
  destination = "/etc/neutron/ovn-nb-ovsdb-user-neutron.rendered"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart neutron-ovn-metadata-agent || true"
  }
}

# OVN SB OVSDB CA
template {
  source = "/etc/consul-template/templates/neutron/ovn-sb-ovsdb-ca.crt.ctmpl"
  destination = "/etc/neutron/ovn-sb-ovsdb-ca.crt"
  create_dest_dirs = false
  perms = "0644"
  exec {
    command = "sudo systemctl reload-or-restart neutron-ovn-metadata-agent || true"
  }
}

# OVN SB OVSDB User
template {
  source = "/etc/consul-template/templates/neutron/ovn-sb-ovsdb-user-neutron.ctmpl"
  destination = "/etc/neutron/ovn-sb-ovsdb-user-neutron.rendered"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart neutron-ovn-metadata-agent || true"
  }
}

# Metadata Agent Config
template {
  source = "/etc/consul-template/templates/neutron/neutron_ovn_metadata_agent.ini.ctmpl"
  destination = "/etc/neutron/neutron_ovn_metadata_agent.ini"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart neutron-ovn-metadata-agent || true"
  }
}