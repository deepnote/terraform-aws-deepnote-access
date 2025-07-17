output "engineer_role_arn" {
  description = "ARN of the Deepnote engineer role"
  value       = module.deepnote_iam.engineer_role_arn
}

output "admin_role_arn" {
  description = "ARN of the Deepnote admin role"
  value       = module.deepnote_iam.admin_role_arn
}

output "engineer_role_name" {
  description = "Name of the engineer role"
  value       = module.deepnote_iam.engineer_role_name
}

output "admin_role_name" {
  description = "Name of the admin role"
  value       = module.deepnote_iam.admin_role_name
}
