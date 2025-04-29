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

# OVSDB CA
template {
  source = "/etc/consul-template/templates/ovn/ovn-sb-ovsdb-ca.crt.ctmpl"
  destination = "/etc/ovn-ovs/ovn-sb-ovsdb-ca.crt"
  create_dest_dirs = false
  perms = "0644"
  exec {
    command = "sudo /usr/local/share/ovn/configure && sudo systemctl reload-or-restart ovn-controller || true"
  }
}

# OVSDB User Northd
template {
  source = "/etc/consul-template/templates/ovn/ovn-sb-ovsdb-user-ovn-controller.ctmpl"
  destination = "/etc/ovn-ovs/ovsdb-user-ovn-controller.ctmpl.rendered"
  create_dest_dirs = false
  perms = "0644"
  exec {
    command = "sudo /usr/local/share/ovn/configure && sudo systemctl reload-or-restart ovn-controller || true"
  }
}