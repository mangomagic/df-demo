# Provider configuration for LocalStack
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  access_key = "test" # Default LocalStack credentials
  secret_key = "test" # Default LocalStack credentials
  region     = "us-east-1"

  # Skip AWS validations since we're using LocalStack
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  s3_use_path_style = true

  # LocalStack endpoint
  endpoints {
    s3 = "http://s3.localhost.localstack.cloud:4566"
  }
}
