# ansible_openstack-nova-compute
Ansible to Install OpenStack Nova on a Compute Host

## Setup

Install Ubuntu Server 24.04.

After the installation finished, before rebooting, enter the shell and run the following:

```bash
chroot /target
```

```bash
cloud-init --debug clean --logs --configs all
/etc/cloud/clean.d/99-installer
truncate -s 0 /etc/machine-id
```

Copy the contents of `${hostname}.nocloud.yaml` into `/etc/cloud/cloud.cfg.d/nocloud.cfg`

Exit the chroot and reboot

## Run

```bash
ansible-galaxy install -r requirements.yml --force --keep-scm-meta
ansible-playbook -i hosts site.yaml -v --diff
```