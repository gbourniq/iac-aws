variable "debug" {
  type        = bool
  description = "placeholder"
}

variable "aws_pem_key_file" {
  type        = string
  description = "placeholder"
}

variable "aws_pem_key_name" {
  type        = string
  description = "placeholder"
}

# variable "github_ssh_key" {
#   type = string
# }

variable "instance_names" {
  type        = list(string)
  description = "placeholder"
}

variable "sg_ports" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [80, 443]
}

variable "environment" {
  type        = string
  description = "placeholder"
  default     = "dev"

  validation {
    condition     = can(regex("^(dev|prod)$", var.environment))
    error_message = "The environment must be set to dev or prod to be valid."
  }
}

variable "vpn_ip" {
  type        = string
  description = "your IP address for ssh access"
}

variable "instance_type" {
  type        = map(string)
  description = "placeholder"
  default = {
    default = "t2.micro"
    dev     = "t2.micro"
    prd     = "t2.large"
  }
}