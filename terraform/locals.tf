# Local variables for reusable values across the configuration
locals {
  # Common tags applied to all buckets
  common_tags = {
    ManagedBy = "Terraform" # Indicates resource is managed by Terraform
  }

  # Merged tags combining common_tags with environment and additional_tags
  bucket_tags = merge(
    local.common_tags,
    { Environment = var.environment },
    var.additional_tags
  )
}
