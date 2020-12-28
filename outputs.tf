output "linuxkit_role_arn" {
  value       = aws_iam_role.linuxkit.arn
  description = "ARN of the created role for use by LinuxKit during image import."
}

output "linuxkit_group" {
  value       = var.create_group ? aws_iam_group.linuxkit[0].name : null
  description = "Name of the group permitted to assume the LinuxKit role."
}
