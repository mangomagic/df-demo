# S3: "cloudfront-logs" with versioning disabled
resource "aws_s3_bucket" "cloudfront_logs" {
  bucket = "cloudfront-logs"

  tags = {
    Name        = "CloudFront Logs"
    Environment = "Test"
  }
}

resource "aws_s3_bucket_versioning" "cloudfront_logs_versioning" {
  bucket = aws_s3_bucket.cloudfront_logs.id
  versioning_configuration {
    status = "Disabled"
  }
}


resource "aws_s3_bucket_server_side_encryption_configuration" "cloudfront_logs_encryption" {
  bucket = aws_s3_bucket.cloudfront_logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "cloudfront_logs_public_access" {
  bucket                  = aws_s3_bucket.cloudfront_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "cloudfront_logs_ownership" {
  bucket = aws_s3_bucket.cloudfront_logs.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_policy" "cloudfront_logs_policy" {
  bucket = aws_s3_bucket.cloudfront_logs.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.cloudfront_logs.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_lifecycle_configuration" "cloudfront_logs_lifecycle" {
  bucket = aws_s3_bucket.cloudfront_logs.id

  rule {
    id     = "expire-logs"
    status = "Enabled"

    filter {
      prefix = "logs/"
    }

    expiration {
      days = 90
    }
  }
}

