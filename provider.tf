terraform {
  # Add this line (adjust the version to match your environment)
  required_version = "1.14.8"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.40.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}