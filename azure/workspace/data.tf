data "terraform_remote_state" "trust" {
  backend = "local"
  config = {
    path = "../trust/terraform.tfstate"
  }
}
