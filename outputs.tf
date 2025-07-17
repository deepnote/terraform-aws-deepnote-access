output "engineer_role_arn" {
  description = "ARN of the Deepnote engineer role"
  value       = aws_iam_role.engineer_role.arn
}

output "admin_role_arn" {
  description = "ARN of the Deepnote admin role"
  value       = aws_iam_role.admin_role.arn
}

output "engineer_role_name" {
  description = "Name of the engineer role"
  value       = aws_iam_role.engineer_role.name
}

output "admin_role_name" {
  description = "Name of the admin role"
  value       = aws_iam_role.admin_role.name
}
