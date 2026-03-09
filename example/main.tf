terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

# Provider configuration goes in the root module
provider "aws" {
  region  = "us-west-2" # Change to your preferred region
  profile = ""          # Optional: specify AWS profile
}

module "deepnote_iam" {
  source      = "github.com/deepnote/terraform-aws-deepnote-access?ref=v1.2.0"
  name_prefix = "deepnote" # a prefix for the resources
}
