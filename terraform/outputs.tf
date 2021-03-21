output "arns" {
  description = "Arns of the created ec2 instances"
  value       = module.myec2instances.*.arn
}

output "workspace_name" {
  description = "Workspace used to create resources"
  value       = terraform.workspace
}
