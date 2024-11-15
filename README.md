# Cloud Environment Provisioning with Terraform on CSC OpenStack

This project demonstrates how to provision a cloud environment using Terraform with CSC’s OpenStack `cPouta` cloud service. The setup includes multiple virtual machines with specific networking and security configurations.

## Table of Contents
- [Introduction](#introduction)
- [Environment Overview](#environment-overview)
- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
  - [1. Install Terraform](#1-install-terraform)
  - [2. Configure OpenStack Provider](#2-configure-openstack-provider)
  - [3. Create Security Groups](#3-create-security-groups)
  - [4. Define Virtual Machines](#4-define-virtual-machines)
  - [5. Apply the Configuration](#5-apply-the-configuration)
  - [6. Generate Graph of Resources](#6-generate-graph-of-resources)
- [Commands Summary](#commands-summary)

## Introduction
This Terraform project automates the setup of a cloud environment using CSC’s OpenStack infrastructure. It consists of provisioning multiple virtual machines, associating a public IP, and applying network security rules, all within a defined project network.

## Environment Overview

The environment includes:
1. **Four Virtual Machines (VMs)**:
   - **VM1**: Connected to the internet with a floating IP.
   - **VMs 2–4**: Connected to the private network without internet access.
2. **Security Groups**:
   - **SSH-HTTP Security Group**: Allows SSH (port 22) and HTTP (port 80) access to VM1 from any IP and unrestricted access from within the project network.
   - **Private-Only Security Group**: Allows all traffic within the project network for VMs 2–4.

## Prerequisites

1. **Terraform**: Ensure Terraform is installed on your local machine. ([Download Terraform](https://www.terraform.io/downloads))
2. **OpenStack CLI**: Access to the OpenStack CLI with credentials to your CSC account.
3. **OpenStack RC File v3**: Download the RC file from your CSC project and source it to authenticate.

## Setup Instructions

### 1. Install Terraform

To install Terraform on Ubuntu:
```bash
sudo apt update
sudo apt install -y unzip
wget https://releases.hashicorp.com/terraform/<latest_version>/terraform_<latest_version>_linux_amd64.zip
unzip terraform_<latest_version>_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

### 2. Configure OpenStack Provider

- In the `terraform` directory, create a file named `providers.tf` and configure it with OpenStack provider details:
  
```hcl
provider "openstack" {
  auth_url          = var.OS_AUTH_URL
  region            = var.OS_REGION_NAME
  tenant_name       = var.OS_PROJECT_NAME
  user_domain_name  = var.OS_USER_DOMAIN_NAME
  user_name         = ""       
  password          = ""       
}
```

### 3. Create Security Groups

Define the required security groups in `main.tf`:
- **SSH-HTTP Security Group**: Allows inbound SSH and HTTP traffic on VM1.
- **Private-Only Security Group**: Allows unrestricted traffic within the project network for VMs 2–4.

### 4. Define Virtual Machines

Specify the VM resources and configurations in `main.tf`:
- VM1 will have a public IP address and security rules for SSH and HTTP.
- VMs 2–4 will be connected to the private network only, with unrestricted project network access.

### 5. Apply the Configuration

To deploy the configuration:
1. **Initialize Terraform** to download the OpenStack provider plugin:
   ```bash
   terraform init
   ```
2. **Plan** the configuration to review the resources that will be created:
   ```bash
   terraform plan
   ```
3. **Apply** the configuration to create the resources:
   ```bash
   terraform apply
   ```

### 6. Generate Graph of Resources

After applying the configuration, generate a graph of the environment’s resources:

```bash
terraform graph -type=plan | dot -Tpng > graph.png
```

This graph provides a visual representation of the resource dependencies and relationships.

## Commands Summary

- **Initialize Terraform**:
  ```bash
  terraform init
  ```
- **Plan the Deployment**:
  ```bash
  terraform plan
  ```
- **Apply the Configuration**:
  ```bash
  terraform apply
  ```
- **Destroy Resources** (only if needed):
  ```bash
  terraform destroy
  ```

# Notes

## Terraform Variables for OpenStack

### os_region_name
Specifies the OpenStack region. Each region may have different availability zones, resources, or configurations. Specifying the region ensures Terraform targets the correct location for deploying resources.

### os_project_name
Defines the project (or tenant) in OpenStack. Each project usually has its own set of resources, quotas, and permissions. The `project_name` ensures Terraform operates within the correct OpenStack project.

### os_user_domain_name
Defines the domain used for identity and authentication in OpenStack. Domains organize users and their permissions, supporting multi-tenancy by allowing isolated projects and resources for departments, teams, or clients.


## Key info:

- **Security**: For production use, ensure your SSH keys and credentials are managed securely.
