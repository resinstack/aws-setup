output "linuxkit_role_arn" {
  value = aws_iam_role.linuxkit.arn
}

output "linuxkit_group_arn" {
  value = aws_iam_group.linuxkit.arn
}
