## Used for deleting resources ##
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.49.0"
    }
  }
  cloud {
    organization = "amora-hc"
    workspaces {
      name = "aws-cloud-dynamic-credentials"
    }
  }
}
