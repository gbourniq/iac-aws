# Set shell
SHELL=/bin/bash -e -o pipefail

.PHONY: up down lint
	
apply:
	terraform init
	terraform fmt -recursive
	terraform validate
	terraform plan -out=./.terraform/terraform_plan
	terraform apply ./.terraform/terraform_plan

graph:
	terraform graph > ./terraform/graph.dot
	cat graph.dot | dot -Tsvg > ./terraform/graph.svg
	open -a "Google Chrome" ./terraform/graph.svg

state-list:
	terraform state list


# ### Other Terraform commands
# terraform destroy --auto-approve

# ### Commands used for State Management
# terraform state show aws_instance.myec2
# terraform state list
# terraform state mv aws_instance.webapp aws_instance.myec2
# terraform state pull | jq []
# terraform state rm aws_instance.myec2

# ### Terraform Workspace commands
# terraform workspace -h
# terraform workspace show
# terraform workspace new dev
# terraform workspace new prd
# terraform workspace list
# terraform workspace select dev

# # Test Terraform functions via the console
# terraform console