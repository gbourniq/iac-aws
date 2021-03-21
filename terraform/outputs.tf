output "arns" {
  description = "Arns of the created ec2 instances"
  value       = module.myec2instance.*.arn
}
