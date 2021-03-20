provider "aws" {
  # alias   = "default"
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
}

locals {
  common_tags = {
    Owner         = "DevOps Team"
    Service       = "backend"
    LastUpdatedAt = local.time
  }
}

resource "aws_instance" "myec2" {
  ami                    = data.aws_ami.app_ami.id
  key_name               = var.aws_pem_key_name
  instance_type          = lookup(var.instance_type, terraform.workspace, "t2.micro")
  count                  = terraform.workspace == "default" ? 1 : 0
  vpc_security_group_ids = [aws_security_group.dynamicsg.id]
  tags                   = local.common_tags

  provisioner "remote-exec" {
    on_failure = fail
    inline = [
      "sudo yum -y install nano"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.aws_pem_key_file)
    host        = self.public_ip
  }

  provisioner "local-exec" {
    command = "echo ${self.private_ip} - ${element(var.elb_names, count.index)} - ${local.time} >> provisioning.log"
  }
}

resource "aws_s3_bucket" "mys3" {
  bucket = "s3-bucket-created-from-tf"
}

resource "aws_security_group" "dynamicsg" {
  name        = "dynamic-sg"
  description = "Ingress for Vault"

  dynamic "ingress" {
    for_each = var.sg_ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpn_ip]
  }
  egress {
    description = "Outbound Allowed"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# put all the above into the internal ec2 module
# module "ec2module" {
#   source        = "./modules/ec2"
#   image_id      = data.aws_ami.app_ami.id
#   instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
# }

# use a public official for dummy s3 bucket 
# module "ec2_cluster" {
#   # https://registry.terraform.io/
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "~> 2.0"

#   name           = "my-cluster"
#   instance_count = 1

#   ami           = "ami-0d6621c01e8c2de2c"
#   instance_type = "t2.micro"
#   subnet_id     = "subnet-4dbfb206"

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }