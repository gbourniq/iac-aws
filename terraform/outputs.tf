
output "timestamp" {
  value = local.time
}

output "arns" {
  value = aws_instance.myec2[*].arn
}

output "aws_pem_key_file" {
  value     = var.aws_pem_key_name
  sensitive = true
}

