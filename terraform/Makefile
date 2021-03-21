# Set shell
SHELL=/bin/bash -e -o pipefail

# Cloudformation

.PHONY: up down lint

up:
	@ bash ./cloudformation/scripts/create-stack.sh

down:
	@ bash ./cloudformation/scripts/delete-stack.sh

lint:
	@ bash ./cloudformation/scripts/lint-cfn-template.sh


# Terraform

terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
terraform graph > graph.dot
cat graph.dot | dot -Tsvg > graph.svg
open graph.svg

# for using with scripts:
terraform plan -out=demopath
terraform apply demopath

# Commands used for State Management
terraform state show aws_instance.myec2
terraform state list
terraform state mv aws_instance.webapp aws_instance.myec2
terraform state pull | jq []
terraform state rm aws_instance.myec2

### Terraform Workspace commands
terraform workspace -h
terraform workspace show
terraform workspace new dev
terraform workspace new prd
terraform workspace list
terraform workspace select dev

# Test Terraform functions via the console
terraform console