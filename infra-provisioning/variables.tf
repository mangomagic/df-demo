# Environment variable to distinguish between deployments (e.g., test, prod)
variable "environment" {
  description = "Deployment environment for the buckets (e.g., test, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["test", "dev", "prod"], var.environment)
    error_message = "Environment must be one of 'test', 'dev', or 'prod'."
  }
}

# Additional tags for cost allocation and governance
variable "additional_tags" {
  description = "Additional tags to apply to all buckets for custom metadata"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.additional_tags : length(k) > 0 && length(v) > 0])
    error_message = "All additional tags must have non-empty keys and values."
  }
}

# Retention period for CloudFront logs in days
variable "cloudfront_logs_retention_days" {
  description = "Number of days to retain CloudFront logs before expiration"
  type        = number
  default     = 30

  validation {
    condition     = var.cloudfront_logs_retention_days >= 30 && var.cloudfront_logs_retention_days <= 3650
    error_message = "Retention period must be between 30 and 3650 days (10 years)."
  }
}

# Retention period for Wizards bucket noncurrent versions in days
variable "wizards_version_retention_days" {
  description = "Number of days to retain noncurrent versions in the Wizards bucket"
  type        = number
  default     = 7

  validation {
    condition     = var.wizards_version_retention_days >= 7 && var.wizards_version_retention_days <= 365
    error_message = "Version retention must be between 7 and 365 days."
  }
}
