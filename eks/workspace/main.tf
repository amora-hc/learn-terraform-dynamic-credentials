data "tfe_project" "default" {
  name         = var.tfc_project_name
  organization = var.tfc_organization_name
}

resource "tfe_oauth_client" "default" {
  name             = "GitHub-OAuth"
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  service_provider = "github"
  organization     = var.github_organization
  oauth_token      = var.github_oauth_token
}

## OPTIONAL: reuse existing TFC oauth client for authentication to Github
/*data "tfe_oauth_client" "azuredevops" {
  organization = var.tfc_organization_name
  name         = var.tfc_oauth_client
}*/

resource "tfe_workspace" "default" {
  depends_on          = [tfe_oauth_client.default]
  name                = var.tfc_workspace_name
  organization        = var.tfc_organization_name
  working_directory   = var.tfc_working_directory
  auto_apply          = var.auto_apply
  description         = "HCP Terraform AWS dynamic credentials"
  project_id          = data.tfe_project.default.id
  speculative_enabled = true
  terraform_version   = var.terraform_version

  trigger_patterns = [
    "${var.tfc_working_directory}/**"
  ]

  vcs_repo {
    branch         = "main"
    identifier     = format("%s/%s", var.github_organization, var.github_repository)
    oauth_token_id = tfe_oauth_client.default.oauth_token_id
    #oauth_token_id = data.tfe_oauth_client.default.oauth_token_id
  }

  lifecycle {
    ignore_changes = [
      tags,
      tag_names
    ]
  }
}

resource "tfe_variable" "enable_kubernetes_provider_auth" {
  key          = "TFC_KUBERNETES_PROVIDER_AUTH"
  value        = "true"
  category     = "env"
  workspace_id = tfe_workspace.default.id
}

resource "tfe_variable" "kubernetes_workload_identity_audience" {
  key          = "TFC_KUBERNETES_WORKLOAD_IDENTITY_AUDIENCE"
  value        = "kubernetes"
  category     = "env"
  workspace_id = tfe_workspace.default.id
}

resource "tfe_variable" "cluster_endpoint_url" {
  key          = "cluster-endpoint-url"
  value        = data.terraform_remote_state.trust.outputs.cluster-endpoint-url
  category     = "terraform"
  workspace_id = tfe_workspace.default.id
}

resource "tfe_variable" "cluster_endpoint_ca" {
  key          = "cluster-endpoint-ca"
  value        = data.terraform_remote_state.trust.outputs.cluster-endpoint-ca
  category     = "terraform"
  workspace_id = tfe_workspace.default.id
  sensitive    = true
}


resource "tfe_variable" "tfe_tf_default" {
  for_each     = var.tfc_terraform_variables
  key          = each.key
  value        = each.value.value
  sensitive    = each.value.sensitive
  category     = "terraform"
  workspace_id = tfe_workspace.default.id
}

resource "tfe_variable" "tfe_env_default" {
  for_each     = var.tfc_environment_variables
  key          = each.key
  value        = each.value.value
  sensitive    = each.value.sensitive
  category     = "env"
  workspace_id = tfe_workspace.default.id
}
