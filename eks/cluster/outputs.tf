# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "cluster-endpoint-url" {
  description = "URL of the cluster API server"
  value       = module.eks.cluster_endpoint
}

output "cluster-endpoint-ca" {
  description = "CA certificate of the cluster API server"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster-name" {
  description = "Name of the EKS cluster"
  value       = var.cluster_name
}

output "cluster-region" {
  description = "Region where the EKS cluster is deployed"
  value       = var.cluster_region
}

output "cluster-role-arn" {
  description = "IAM role ARN used by the EKS cluster (bootstrap role)"
  value       = module.eks.cluster_iam_role_arn
}