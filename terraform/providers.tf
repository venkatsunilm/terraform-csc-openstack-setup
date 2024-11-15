# Define required providers
terraform {
  required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53.0"
    }
  }
}

# Configure the OpenStack Provider
# The values are dynamically picked from the terraform.tfvars for now
provider "openstack" {
  user_name        = var.os_username
  password         = var.os_password
  auth_url         = var.os_auth_url         # "https://pouta.csc.fi:5001/v3"
  region           = var.os_region_name      # "regionOne"
  tenant_name      = var.os_project_name     # "project_2011705"
  user_domain_name = var.os_user_domain_name # "Default"
}
