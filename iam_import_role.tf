data "aws_iam_policy_document" "vmimport" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["vmie.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "sts:Externalid"
      values   = ["vmimport"]
    }
  }
}

resource "aws_iam_role" "vmimport" {
  name               = "vmimport"
  assume_role_policy = data.aws_iam_policy_document.vmimport.json
}

data "aws_iam_policy_document" "vmimport_access" {
  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket"
    ]
    effect = "Allow"
    resources = [
      aws_s3_bucket.staging_bucket.arn,
      "${aws_s3_bucket.staging_bucket.arn}/*"
    ]
  }
  statement {
    actions = [
      "ec2:ModifySnapshotAttribute",
      "ec2:CopySnapshot",
      "ec2:RegisterImage",
      "ec2:Describe*"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "vmimport_access" {
  name   = "VMImportAccess"
  policy = data.aws_iam_policy_document.vmimport_access.json
}

resource "aws_iam_role_policy_attachment" "vmimport_access" {
  role       = aws_iam_role.vmimport.name
  policy_arn = aws_iam_policy.vmimport_access.arn
}
