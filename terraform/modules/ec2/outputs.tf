output "arn" {
  description = "Arn of the created ec2 instance"
  value       = aws_instance.myec2.arn
}

output "private_ip" {
  description = "Private IP of the created ec2 instance"
  value       = aws_instance.myec2.private_ip
}