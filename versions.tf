# terraform block
# Version of terraform, version control of providers
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # version must be greater than or equal to the following values
      version = ">= 4.49.0"
    }
  }

  # Specify TerraformCLI version 1.3.7 or higher and less than 2.0
  required_version = "~> 1.4.0"
}
# Specify regions and set default tags
provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Env   = "TF-Web3-Tier"
      Owner = "kobakichi"
    }
  }
}