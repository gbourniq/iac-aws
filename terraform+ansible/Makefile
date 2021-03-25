# Set shell
SHELL=/bin/bash -e -o pipefail

.PHONY: up down lint
	
apply:
	cd terraform; terraform init
	cd terraform; terraform fmt -recursive
	cd terraform; terraform validate
	cd terraform; terraform plan -out=./.terraform/terraform_plan
	cd terraform; terraform apply ./.terraform/terraform_plan

graph:
	cd terraform; terraform graph > ./.terraform/graph.dot
	cd terraform; cat ./.terraform/graph.dot | dot -Tsvg > ./.terraform/graph.svg
	cd terraform; open -a "Google Chrome" ./.terraform/graph.svg

state-list:
	cd terraform; terraform state list
