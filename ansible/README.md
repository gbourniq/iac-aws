# Ansible documentation

The Ansible playbooks are used to provision ec2 instances with git repositories and development software packages such as docker, anaconda and poetry.

These playbooks are meant to be run automatically from a terraform module, following the creation of ec2 instances.

------------------------------------------

## Overview

#### Ansible inventories

Ansible inventories are a pattern for defining and grouping managed remote hosts. They are located in `ansible/inventories/`. The addresses of the machines that you want to configure are defined in the hosts file under inventories. You can also specify the ssh keys associated with these hosts in this file as well.

Below is an example of `ansible/inventories/staging/hosts` file which contains a list of remote server public IPs and the ssh key file for Ansible to access the instances.

```
[staging]
18.134.226.25
3.10.227.148

[staging:vars]
ansible_ssh_private_key_file=~/.ssh/terraform_login_key.pem
ansible_user=ec2-user
```

#### Ansible playbooks

Playbooks contain the steps which are set to execute on a particular machine.

This repository contains a `staging.yaml` and `production.yaml` playbooks.


#### Ansible roles

Roles can be found in `ansible/roles/common/` and are ways of automatically loading certain vars_files, tasks, and handlers based on a known file structure. Grouping content by roles also allows easy sharing of roles with other users.

For example, the `docker_deployment.yml` playbook runs the `common` role, which in turn, runs a set of tasks defined in `ansible/roles/common/tasks/main.yaml`.


## How to run the playbook

#### Set environment variables for Ansible

The following environment variables are expected to be set in the `.env` file.
```
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault_pass
export DOCKER_USER=<dockerhub user>
```

#### Ansible secrets

Variables that we use for sensitive information like passwords are managed by ansible vault. These are stored in an encrypted file, `secrets.yaml`. A password is required to decrypt this file. For automation we can specify this password in a file stored somewhere secure outside of source control.

```bash
touch ~/.ansible_vault_pass
echo "${MY_ANSIBLE_VAULT_PASSPRASE}" > ~/.ansible_vault_pass
export ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault_pass
ansible-vault encrypt_string '<sensitive-value>' --name '<variable-name>'
```

The encrypted variable can then be stored as an ansible secret in the `secrets.yaml` to be used in ansible roles and playbooks.

So that ansible knows where to look for his file, you should either specify it when running the playbooks with the command line argument `--vault-password-file` or by exporting the `ANSIBLE_VAULT_PASSWORD_FILE` environment variable.

The current playbook expects a `dockerhub_password` secret so that Ansible can log in to dockerhub on the remote servers.


#### Running a playbook

The following command can be run to start the `staging.yaml` playbook. 
```bash
cd ansible
source .env
ansible-playbook -i inventories staging.yaml -v --timeout 60
```
