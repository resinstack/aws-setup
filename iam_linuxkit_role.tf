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

  dynamic "statement" {
    for_each = toset(var.trusted_aws_principals)

    content {
      actions = ["sts:AssumeRole"]
      effect  = "Allow"
      principals {
        type        = "AWS"
        identifiers = [statement.value]
      }
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

resource "aws_iam_group" "linuxkit" {
  count = var.create_group ? 1 : 0

  name = "linuxkit"
}

data "aws_iam_policy_document" "linuxkit_policy" {
  count = var.create_group ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    resources = [
      aws_iam_role.linuxkit.arn,
    ]
  }
}

resource "aws_iam_group_policy" "linuxkit_policy" {
  count = var.create_group ? 1 : 0

  name  = "linuxkit-role-assume"
  group = aws_iam_group.linuxkit[0].id

  policy = data.aws_iam_policy_document.linuxkit_policy[0].json
}
