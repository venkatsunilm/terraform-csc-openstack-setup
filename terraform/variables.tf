# variables.tf

variable "os_username" {
  description = "Username for OpenStack authentication."
  type        = string
}
variable "os_password" {
  description = "Password for OpenStack authentication."
  type        = string
  sensitive   = true
}
variable "os_auth_url" {
  description = "Authentication URL for OpenStack."
  type        = string
}
variable "os_region_name" {
  description = <<-EOT
    Specifies the OpenStack region. Each region may have different 
    availability zones, resources, or configurations. This ensures 
    Terraform targets the correct location for resource deployment.
  EOT
  type        = string
}
variable "os_project_name" {
  description = <<-EOT
    Specifies the project (or tenant) within OpenStack. Each project 
    has its own resources, quotas, and permissions. This ensures that 
    Terraform operates within the specified OpenStack project.
  EOT
  type        = string
}
variable "os_user_domain_name" {
  description = <<-EOT
    Defines the user domain for authentication. Domains in OpenStack 
    manage user and project permissions, supporting multi-tenancy by 
    separating resources for different departments, teams, or clients.
  EOT
  type        = string
}
