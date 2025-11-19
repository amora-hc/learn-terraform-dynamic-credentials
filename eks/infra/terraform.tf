# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.49.0"
    }
  }

  cloud {
    organization = "amora-hc"
    workspaces {
      name = "eks-cloud-dynamic-credentials"
    }
  }
}
