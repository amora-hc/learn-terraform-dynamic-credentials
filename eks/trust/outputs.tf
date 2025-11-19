# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "cluster-endpoint-url" {
  description = "URL of the cluster API server"
  value = data.terraform_remote_state.cluster.outputs.cluster-endpoint-url
}

output "cluster-endpoint-ca" {
  description = "CA certificate of the cluster API server"
  value = data.terraform_remote_state.cluster.outputs.cluster-endpoint-ca
}
