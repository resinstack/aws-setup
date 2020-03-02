output "linuxkit_role_arn" {
  value = aws_iam_role.linuxkit.arn
  description = "ARN of the created role for use by LinuxKit during image import."
}

output "linuxkit_group_arn" {
  value = aws_iam_group.linuxkit.arn
  description = "A group which permits the members to assume the LinuxKit role."
}
