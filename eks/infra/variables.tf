# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "cluster-endpoint-url" {
  type        = string
  description = "URL of GKE cluster's API"
}

variable "cluster-endpoint-ca" {
  type        = string
  description = "Base64 encoded CA certificate of the GKE cluster API endpoint"
}

variable "running_local" {
  default = false
}

variable "cluster_name" {
  description = "Name of target EKS cluster"
  type        = string
  default     = "test-eks-cluster"
}

variable "cluster_region" {
  description = "Location of the EKS cluster"
  type        = string
  default     = "us-east-2"
}
