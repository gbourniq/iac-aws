provider "aws" {
  region  = "eu-west-2"
  profile = "myaws"
}

data "aws_ami" "app_ami" {
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
    Owner         = "DevOps Team"
    Service       = "backend"
    LastUpdatedAt = local.time
  }
}

module "myec2instance" {
  source                 = "./modules/ec2"
  count                  = var.instance_count
  ami                    = data.aws_ami.app_ami.id
  key_name               = var.aws_pem_key_name
  instance_type          = lookup(var.instance_type, var.environment, "t2.micro")
  iam_instance_profile   = var.iam_instance_profile
  vpc_security_group_ids = [module.aws_security_group.id]
  tags                   = local.common_tags
}

module "aws_security_group" {
  source   = "./modules/sg"
  sg_ports = var.sg_ports
  tags     = local.common_tags
  vpn_ip   = var.vpn_ip
}

# Official ec2 module from Terraform public registry
module "ec2_cluster" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name           = "my-cluster"
  instance_count = var.use_official_module == "true" ? 1 : 0
  ami            = data.aws_ami.app_ami.id
  instance_type  = lookup(var.instance_type, terraform.workspace, "t2.micro")
  tags           = local.common_tags
}
