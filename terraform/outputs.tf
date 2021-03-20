output "timestamp" {
  description = "Formatted timestamp"
  value       = local.time
}

output "arns" {
  description = "Arns of the created ec2 instances"
  value       = aws_instance.myec2[*].arn
}

output "aws_pem_key_file" {
  description = "Sensitive variable not displayed in the terminal"
  value       = var.aws_pem_key_name
  sensitive   = true
}
