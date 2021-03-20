variable "instancetype" {
  description = "The type of the EC2 instance."
  default     = "t2.micro"
}

variable "debug" {
  type = bool
}

variable "aws_pem_key_file" {
  type = string
}

variable "aws_pem_key_name" {
  type = string
}

variable "github_ssh_key" {
  type = string
}

variable "elb_names" {
  type = list(string)
}

variable "sg_ports" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [80, 443]
}

variable "environment" {
  type    = string
  default = "dev"

  validation {
    condition     = can(regex("^(dev|prod)$", var.environment))
    error_message = "The environment must be set to dev or prod to be valid."
  }
}

variable "instance_count" {
  type = map(any)
  default = {
    "dev"  = 1
    "prod" = 2
  }
}

variable "vpn_ip" {}

variable "instance_type" {
  type = map(string)

  default = {
    default = "t2.micro"
    dev     = "t2.micro"
    prd     = "t2.large"
  }
}