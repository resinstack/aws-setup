data "aws_caller_identity" "self" {}

data "aws_iam_policy_document" "linuxkit_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.self.account_id]
    }
  }
}

resource "aws_iam_role" "linuxkit" {
  name               = "linuxkit"
  assume_role_policy = data.aws_iam_policy_document.linuxkit_assume.json
}

data "aws_iam_policy_document" "linuxkit_role_policy" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
    ]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.staging_bucket.arn}/*"]
  }
  statement {
    actions = [
      "ec2:ImportSnapshot",
      "ec2:DescribeImportSnapshotTasks",
      "ec2:RegisterImage",
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "linuxkit" {
  name   = "LinuxkitBuild"
  policy = data.aws_iam_policy_document.linuxkit_role_policy.json
}

resource "aws_iam_role_policy_attachment" "linuxkit" {
  role       = aws_iam_role.linuxkit.name
  policy_arn = aws_iam_policy.linuxkit.arn
}

output "linuxkit_role_arn" {
  value = aws_iam_role.linuxkit.arn
}
