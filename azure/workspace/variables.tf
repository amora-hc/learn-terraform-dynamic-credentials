variable "github_organization" {
  type        = string
  description = "Name of the GitHub organization."
}

variable "github_repository" {
  type        = string
  description = "Name of the GitHub repository."
}

variable "github_oauth_token" {
  type        = string
  description = "Github apps personal access token"
}

variable "tfc_organization_name" {
  type        = string
  description = "Name of the TFC organization."
}

variable "tfc_project_name" {
  type        = string
  description = "Name of the TFC project."
}

variable "tfc_workspace_name" {
  type        = string
  description = "Name of the TFC workspace."
}

variable "tfc_working_directory" {
  type        = string
  description = "Working directory for the TFC workspace."
}

variable "auto_apply" {
  type    = bool
  default = false
}

variable "terraform_version" {
  type        = string
  description = "Version of Terraform to use"
  default     = "~> 1.11.0"
}

variable "tfc_terraform_variables" {
  type = map(object({
    value     = string
    sensitive = optional(bool, false)
  }))
  description = "Map of additional Terraform variables"
  default     = {}
}

variable "tfc_environment_variables" {
  type = map(object({
    value     = string
    sensitive = optional(bool, false)
  }))
  description = "Map of additional Envrionment variables"
  default     = {}
}
