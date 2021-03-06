provider "aws" {
  region  = "eu-west-2"
  profile = "myaws"
}

data "aws_ami" "app_ami" {
  # Get the latest Amazon Linux 2 AMI
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

locals {
  time = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
  common_tags = {
    Name          = var.tag_name
    LastUpdatedAt = local.time
  }
}

module "mysecuritygroups" {
  # Call internal module to create security groups
  # Internal module allows to hardcode variables such as the VPN IP range
  source   = "./modules/sg"
  sg_ports = var.sg_ports
  tags     = local.common_tags
  vpn_ip   = var.vpn_ip
}

module "myec2instances" {
  # Call internal module to create ec2 instances
  # Internal module allows to hardcode variables such as a hardened company AMI ID
  source                 = "./modules/ec2"
  count                  = var.instance_count
  ami                    = data.aws_ami.app_ami.id
  key_name               = var.aws_pem_key_name
  instance_type          = lookup(var.instance_type, var.environment, null)
  iam_instance_profile   = var.iam_instance_profile
  vpc_security_group_ids = [module.mysecuritygroups.dynamic_sg_id, module.mysecuritygroups.ssh_sg_id]
  tags                   = local.common_tags
}

resource "local_file" "hosts_inventory_file" {
  # Generate Ansible inventory file
  depends_on = [
    module.myec2instances
  ]
  content = templatefile("${path.module}/templates/staging_hosts.tpl",
    {
      public_ips = module.myec2instances.*.public_ip
    }
  )
  filename = "${path.module}/../ansible/inventories/staging/hosts"
}

resource "null_resource" "cluster_provisioning" {
  # Call Ansible playbook to provision instances
  depends_on = [
    local_file.hosts_inventory_file
  ]
  provisioner "local-exec" {
    command = "sleep 60; source ../.env; ansible-playbook -i ../ansible/inventories ../ansible/staging.yaml --timeout 60"
  }
}

resource "null_resource" "logging" {
  # Call Ansible playbooks to provision instances
  depends_on = [
    null_resource.cluster_provisioning
  ]
  count = length(module.myec2instances.*.arn)
  provisioner "local-exec" {
    command = "echo 'provisioned instance with public ip: ${element(module.myec2instances.*.public_ip, count.index)}'  >> ${var.provisioning_logs}"
  }
}

# module "ec2_cluster" {
#  # Official ec2 module: https://registry.terraform.io
#  # Only used as an example of Terraform public registry module
#  source  = "terraform-aws-modules/ec2-instance/aws"
#  version = "~> 2.0"
#
#  name           = "my-cluster"
#  instance_count = var.environment == "prod" ? 1 : 0
#  ami            = data.aws_ami.app_ami.id
#  instance_type  = lookup(var.instance_type, var.environment, null)
#  tags           = local.common_tags
#}
