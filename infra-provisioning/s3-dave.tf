# S3: "Dave" with versioning disabled
resource "aws_s3_bucket" "dave" {
  bucket = "dave"

  tags = {
    Name        = "Dave"
    Environment = "Test"
  }
}

resource "aws_s3_bucket_versioning" "dave_versioning" {
  bucket = aws_s3_bucket.dave.id
  versioning_configuration {
    status = "Disabled"
  }
}

#
# Code below would create a KMS key and apply to bucket
# Currently not working with localstack
#

# Create a KMS Key
# resource "aws_kms_key" "dave_kms_key" {
#   description             = "KMS key for Dave's S3 bucket"
#   key_usage               = "ENCRYPT_DECRYPT"
#   deletion_window_in_days = 10

#   tags = {
#     Name        = "Dave KMS Key"
#     Environment = "Test"
#   }
# }

# S3 bucket encryption configuration
# resource "aws_s3_bucket_server_side_encryption_configuration" "dave_encryption" {
#   bucket = aws_s3_bucket.dave.id
#   rule {
#     apply_server_side_encryption_by_default {
#       sse_algorithm     = "aws:kms"
#       kms_master_key_id = aws_kms_key.dave_kms_key.id # Use the KMS key
#     }
#   }
# }

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
