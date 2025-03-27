# S3: "wizards" with versioning enabled
resource "aws_s3_bucket" "wizards" {
  bucket = "wizards"

  tags = {
    Name        = "Wizards"
    Environment = "Test"
  }
}

resource "aws_s3_bucket_versioning" "wizards_versioning" {
  bucket = aws_s3_bucket.wizards.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "wizards_encryption" {
  bucket = aws_s3_bucket.wizards.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "wizards_public_access" {
  bucket                  = aws_s3_bucket.wizards.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "wizards_ownership" {
  bucket = aws_s3_bucket.wizards.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
