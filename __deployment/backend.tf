# Remote state storage allows us to keep our .tfstate files externally and remotely.
# Here we're using Hashicorp's free Terraform Cloud service to store state.

# We use the .gitlab-ci file to insert the value of the API key into here with sed
# (in place of the text that reads "CHANGEME")
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "alexhaydock"
    token        = "CHANGEME"
    workspaces {
      name = "prod_infra_xyz_darkwebkittens"
    }
  }
}