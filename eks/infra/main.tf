# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region                      = var.cluster_region
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_requesting_account_id  = true
}

data "aws_eks_cluster" "upstream" {
  count = var.running_local ? 1 : 0
  name  = var.cluster_name
}

data "aws_eks_cluster_auth" "upstream_auth" {
  count = var.running_local ? 1 : 0
  name  = var.cluster_name
}

provider "kubernetes" {
  host                   = var.running_local ? data.aws_eks_cluster.upstream[0].endpoint : var.cluster-endpoint-url
  cluster_ca_certificate = var.running_local ? base64decode(data.aws_eks_cluster.upstream[0].certificate_authority[0].data) : base64decode(var.cluster-endpoint-ca)
  token                  = var.running_local ? data.aws_eks_cluster_auth.upstream_auth[0].token : null
  // Auth token value will be obtained from the KUBE_TOKEN environment variable,
  // which gets automatically set by Terraform Cloud
}

resource "kubernetes_config_map" "test" {
  metadata {
    name = "test"
  }

  data = {
    "foo" = "bar"
  }
}
