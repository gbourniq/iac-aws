## Objective

This repository consists of a CloudFormation template and helper scripts.
The objective is to create and provision an AWS EC2 instance with a configured Python project, and optionally run commands against it.

More specifically, the CloudFormation template performs the following operations:
1. Launch a configurable EC2 instance (parameters include AMI, Instance type, Volume size, etc.)
2. Enable CloudWatch (CW) so that the EC2 instance can send logs in real time to the CW service - Very helpful to monitor the stack creation progress
3. Install a given version of Miniconda, Python, and Poetry to manage project dependencies
4. Clone a given repository and checkout to a given branch
5. Run a user defined script via the `files/ec2_run_script.sh`, eg (Activate environment, do x,y,z with the repo...)
6. Send the CW logs to the given S3 bucket for archival
7. Optionally delete the stack upon the `files/ec2_run_script.sh` completion

## AWS Prerequisites

In order to launch the stack, it is assumed that the following prerequisites are met.
1. Create an AWS account
2. Install the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) and run `aws configure`
3. Create a Parameter `github_ssh_private_key` in the AWS Parameter Store (System Manager) - The content of this parameter is the private SSH key to clone repositories.
4. Create an EC2 Key Pair to be able to SSH into the created instances
5. Create an S3 Bucket for storing files used during the stack creation

## Parameters

The following parameters, defined in `parameters.json`, are used by the CloudFormation template `cfn-template.yaml` to configure the stack deployment.

* EC2 Instance configuration

|**Name**                      |**Description**                                                               |
|------------------------------|------------------------------------------------------------------------------|
|`InstanceType`                | Type of the instance to create, eg. t2.micro                                 |
|`EC2HomeDirectory`            | Path to the user home directory, eg. /home/ec2-user/ for Amazon Linux 2      |
|`KeyName`                     | Key Pair name used to create the instance and ssh into it                    |
|`VolumeSize`                  | Size of the volume attached to the instance (GB)                             |
|`S3BucketName`                | S3 bucket name to store files used during the stack creation (eg. CW config) |
|`S3FilePathCloudWatchConfig`  | S3 Path for CW config, default files/cloud_watch_config.json                 |
|`S3FilePathEC2ScriptToRun`    | S3 Path for ec2 script, default files/ec2_run_script.sh                      |

* Python project environment configuration

|**Name**                      |**Description**                                                               |
|------------------------------|------------------------------------------------------------------------------|
|`CondaVersion`                | Version of the Miniconda distribution to install, default 4.8.3              |
|`PythonVersion`               | Version of the Python distribution to install, default 3.7                   |
|`PoetryVersion`               | Version of the Poetry distribution to install, default 0.12.17               |
|`RepositoryName`              | Name of the repository to git clone                                          |
|`BranchName`                  | Name of the branch to git checkout to                                        |
|`GithubSSHKey`                | AWS SSM Parameter Name which stores the Github SSH key (SecureString)        |

The following environment variables can be set before running the scripts, and default values are specified within scripts

|**Name**                      |**Description**                                                               |
|------------------------------|------------------------------------------------------------------------------|
|`STACK_NAME`                  | Name of the stack to create                                                  |
|`MAX_TIME_MINUTES`            | Time limit to create the stack because it is flagged as failed               |
|`CFN_BUCKET_NAME`             | S3 bucket name /!\ Must be the same as `S3BucketName` in parameters.json     |
|`DELETE_STACK_ON_COMPLETION`  | Set True to del. the stack automatically upon `ec2_run_script.sh` completion |


## Commands

A `Makefile` is available to easily create and delete a stack.

|**Command**                   |**Description**                                                               |
|------------------------------|------------------------------------------------------------------------------|
|`make up`                     | Create the stack and poll for completion status                              |
|`make down`                   | Delete the stack and poll for deletion status                                |
|`make lint`                   | Lint the cloudformation template with `yamllint` and `cfn-lint`              |
