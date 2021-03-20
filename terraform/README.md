Prerequisites:
- Install terraform
- terraform-docs: https://github.com/terraform-docs/terraform-docs
- tflint: https://github.com/terraform-linters/tflint
- Install pre-commit
- Install graphviz


use ansible to configure EC2 with simple stuff

Variables and outputs should have descriptions. All variables and outputs should have one or two sentence descriptions that explain their purpose.



High level plan:
- make it functional (same stuff as cfn, git clone etc. take a note of what's left, eg. cw logs)
- use ansible for all the configuration stuff?
- make it look nice (descriptions, comments, etc)
- turn it into an internal module (generalised files)
- use a public module from a public registry (maybe s3)
- clean up repo, pre-commit, makefile, cicd?