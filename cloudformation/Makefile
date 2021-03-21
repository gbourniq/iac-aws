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
