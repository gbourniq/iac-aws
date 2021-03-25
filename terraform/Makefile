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
	terraform graph > ./.terraform/graph.dot
	cat ./.terraform/graph.dot | dot -Tsvg > ./.terraform/graph.svg
	open -a "Google Chrome" ./.terraform/graph.svg

state-list:
	terraform state list
