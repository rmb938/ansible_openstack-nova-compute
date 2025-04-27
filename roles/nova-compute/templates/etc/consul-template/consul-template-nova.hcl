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

# RabbitMQ CA
template {
  source = "/etc/consul-template/templates/nova/rabbitmq-server-ca.crt.ctmpl"
  destination = "/etc/nova/rabbitmq-server-ca.crt"
  create_dest_dirs = false
  perms = "0644"
  exec {
    command = "sudo systemctl reload-or-restart nova-compute || true"
  }
}

# RabbitMQ User
template {
  source = "/etc/consul-template/templates/nova/rabbitmq-user-nova-compute.ctmpl"
  destination = "/etc/nova/rabbitmq-user-nova-compute.rendered"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart nova-compute || true"
  }
}

# Nova Config
template {
  source = "/etc/consul-template/templates/nova/nova.conf.ctmpl"
  destination = "/etc/nova/nova.conf"
  create_dest_dirs = false
  perms = "0600"
  exec {
    command = "sudo systemctl reload-or-restart nova-compute || true"
  }
}