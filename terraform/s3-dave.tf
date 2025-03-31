# S3: "Dave" with versioning disabled
resource "aws_s3_bucket" "dave" {
  bucket = "dave-${var.environment}"

  tags = merge(local.bucket_tags, { Name = "Dave" })
}

resource "aws_s3_bucket_versioning" "dave_versioning" {
  bucket = aws_s3_bucket.dave.id
  versioning_configuration {
    status = "Disabled"
  }
}

# AWS Server Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "dave_encryption" {
  bucket = aws_s3_bucket.dave.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "dave_public_access" {
  bucket                  = aws_s3_bucket.dave.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "dave_ownership" {
  bucket = aws_s3_bucket.dave.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
