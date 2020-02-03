resource "aws_s3_bucket" "staging_bucket" {
  bucket = var.bucket_name
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "staging_bucket" {
  bucket = aws_s3_bucket.staging_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
