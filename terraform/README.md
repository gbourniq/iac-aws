### Pre-requisites

Install the following software and packages on your local machine:
- [terraform cli](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [terraform-docs](https://github.com/terraform-docs/terraform-docs)
- [tflint](https://github.com/terraform-linters/tflint)
- [pre-commit](https://pre-commit.com)
- [graphviz](https://graphviz.org/download/)
- [ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

### 1. Create a terraform.tfvars file

```bash
cp terraform.tfvars.template terraform.tfvars
```

The `terraform.tfvars` is used to specify Terraform variables such as the number of ec2 instances to create, and the local machine IP or VPN IP range which should be allowed for inbound ssh connection.

### 2. Configure Ansible

Configure ansible variables as per the instructions in `ansible/README.md`.

### 3. Create and configure infrastructure

The `make apply` command can be run to automatically create and configure the remote servers.

Other useful make commands can be found in the `Makefile`.

### Other useful Terraform commands

Get a human-readable output from a state or plan file.
```
terraform show
```

Extract the value of an output variable from the state file.
```
terraform output
```

Automatically destroy all infrastructure without the user prompt.
```
terraform destroy --auto-approve
```

Commands used for State Management
```
terraform state show aws_instance.myec2
terraform state list
terraform state mv aws_instance.webapp aws_instance.myec2
terraform state pull | jq []
terraform state rm aws_instance.myec2
```

Terraform Workspace commands
```
terraform workspace -h
terraform workspace show
terraform workspace new dev
terraform workspace new prd
terraform workspace list
terraform workspace select dev
```

Test Terraform functions via the console
```
terraform console
```