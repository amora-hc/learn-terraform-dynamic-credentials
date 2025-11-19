terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.100"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23.0"
    }
  }
}
