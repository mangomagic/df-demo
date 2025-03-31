output "dave_bucket_arn" {
  description = "ARN of the Dave bucket"
  value       = aws_s3_bucket.dave.arn
}

output "wizards_bucket_arn" {
  description = "ARN of the Wizards bucket"
  value       = aws_s3_bucket.wizards.arn
}

output "cloudfront_logs_bucket_arn" {
  description = "ARN of the CloudFront Logs bucket"
  value       = aws_s3_bucket.cloudfront_logs.arn
}

output "all_bucket_names" {
  description = "List of all bucket names"
  value = [
    aws_s3_bucket.dave.id,
    aws_s3_bucket.wizards.id,
    aws_s3_bucket.cloudfront_logs.id
  ]
}
