#!/usr/bin/env bash

set -e

# Variables: set with Environment Variable or revert to default value
AWS_DEFAULT_PROFILE="${AWS_DEFAULT_PROFILE:-personal}"
STACK_NAME="${STACK_NAME:-myfirststack}"
MAX_TIME_MINUTES="${MAX_TIME_MINUTES:-10}"
CFN_BUCKET_NAME="${CFN_BUCKET_NAME:-cf-templates-10gg34q658sj6-eu-west-2}"
DELETE_STACK_ON_COMPLETION="${DELETE_STACK_ON_COMPLETION:-False}"

# Stack tags
NAME="Test Stack"
LAUNCH_DATE="$(date +%F_%T)"
EMAIL="gbournique@gmail.com"

# File paths
SCRIPT_DIR="${SCRIPT_DIR:-$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )}"
BASE_DIR="${BASE_DIR:-$(dirname "$SCRIPT_DIR")}"
CFN_TEMPLATE_FILE="${CFN_TEMPLATE_FILE:-$BASE_DIR/cfn-template.yaml}"
CFN_PARAMETERS_FILE="${CFN_PARAMETERS_FILE:-$BASE_DIR/parameters.json}"
FILES_DIR="${FILES_DIR:-$BASE_DIR/files}"
CW_CONFIG_FILE="${CW_CONFIG_FILE:-$FILES_DIR/cloud_watch_config.json}"
EC2_SCRIPT_FILE="${EC2_SCRIPT_FILE:-$FILES_DIR/ec2_run_script.sh}"

# Helper functions
function exit_error() {
  echo "$1" 1>&2
  exit 1
}

function get_stack_status()
{
    STACK_STATUS=$(aws cloudformation describe-stacks --stack-name=${STACK_NAME} | jq -r '.Stacks[0].StackStatus')
    echo ${STACK_STATUS}
}

# Validate stack
if ! (aws cloudformation validate-template --template-body file://"${CFN_TEMPLATE_FILE}" > /dev/null 2>&1)
then
  exit_error "CloudFormation template validation failed!  Aborting."
fi

# Upload files to S3, which will be used during stack creation
aws s3 cp "${CW_CONFIG_FILE}" s3://${CFN_BUCKET_NAME}/files/cloud_watch_config.json
aws s3 cp "${EC2_SCRIPT_FILE}" s3://${CFN_BUCKET_NAME}/files/ec2_run_script.sh

# Create the stack
echo "Creating stack ${STACK_NAME}..."
aws cloudformation create-stack \
    --stack-name=${STACK_NAME} \
    --template-body=file://"${CFN_TEMPLATE_FILE}" \
    --parameters=file://"${CFN_PARAMETERS_FILE}" \
    --tags "Key"="Name","Value"="${NAME}" "Key"="Date","Value"="${LAUNCH_DATE}" "Key"="Email","Value"="${EMAIL}" \
    --disable-rollback \
    --timeout-in-minutes=${MAX_TIME_MINUTES} \
    --profile=${AWS_DEFAULT_PROFILE} \
    --capabilities=CAPABILITY_IAM

# Check Stack creation status
while [[ "$(get_stack_status)" == "CREATE_IN_PROGRESS" ]]; do
    echo "Stack creation in progress 🚀"
    sleep 30
done

if [[ "$(get_stack_status)" == "CREATE_COMPLETE" ]]; then
    echo "Stack creation completed! ✅"
else
    exit_error "Oops, something went wrong during stack creation ❌"
fi

if [[ $DELETE_STACK_ON_COMPLETION == True ]]; then
    echo "DELETE_STACK_ON_COMPLETION is enabled"
    "${SCRIPT_DIR}"/delete-stack.sh
fi