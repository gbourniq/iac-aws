variable "image_id" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."

  validation {
    condition     = can(regex("^ami-", var.image_id))
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  }
}

variable "instance_type" {
  description = "The type of the EC2 instance."
  type        = string
  default     = "t2.micro"
  validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^t2.micro$", var.instance_type))
    error_message = "The instance_type value must match the allowed pattern(s)."
  }
}