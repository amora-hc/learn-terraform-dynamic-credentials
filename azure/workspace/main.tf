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
  description         = "HCP Terraform Azure dynamic credentials"
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

resource "tfe_variable" "enable_azure_provider_auth" {
  key          = "TFC_AZURE_PROVIDER_AUTH"
  value        = "true"
  category     = "env"
  workspace_id = tfe_workspace.default.id
}

resource "tfe_variable" "azure_run_client_id" {
  key          = "TFC_AZURE_RUN_CLIENT_ID"
  value        = data.terraform_remote_state.trust.outputs.run_client_id
  category     = "env"
  workspace_id = tfe_workspace.default.id
}

resource "tfe_variable" "azure_subscription_id" {
  key          = "ARM_SUBSCRIPTION_ID"
  value        = data.terraform_remote_state.trust.outputs.subscription_id
  category     = "env"
  workspace_id = tfe_workspace.default.id
}

resource "tfe_variable" "azure_tenant_id" {
  key          = "ARM_TENANT_ID"
  value        = data.terraform_remote_state.trust.outputs.tenant_id
  category     = "env"
  workspace_id = tfe_workspace.default.id
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
