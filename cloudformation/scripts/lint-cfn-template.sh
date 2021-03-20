#!/usr/bin/env bash

set -e

# Variables: set with Environment Variable or revert to default value
AWS_DEFAULT_PROFILE="${AWS_DEFAULT_PROFILE:-personal}"
STACK_NAME="${STACK_NAME:-myfirststack}"

# File paths
SCRIPT_DIR="${SCRIPT_DIR:-$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )}"
BASE_DIR="${BASE_DIR:-$(dirname "$SCRIPT_DIR")}"
CFN_TEMPLATE_FILE="${CFN_TEMPLATE_FILE:-$BASE_DIR/cfn-template.yaml}"

# Helper functions
function exit_error() {
  echo "$1" 1>&2
  exit 1
}

# Check if all required commands are available locally
available_commands=0;
REQUIRED_COMMANDS=(yamllint cfn-lint);
for command in "${REQUIRED_COMMANDS[@]}"; do
  if ! (hash "$command" &>/dev/null); then
    echo "$command is not available!"
    echo "Please run 'pip install $command'"
    exit 1
  fi
done

echo "Run yamllint..."
if ! (yamllint -d "{rules: {line-length: {max: 120, level: warning}}}" cfn-template.yaml)
then
  exit_error "Template failed to pass yamllint validation! Aborting."
fi

echo "Run cfn-lint..."
if ! (cfn-lint cfn-template.yaml )
then
  exit_error "Template failed to pass cfn-init validation! Aborting."
fi