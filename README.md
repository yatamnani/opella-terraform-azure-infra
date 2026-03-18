# Opella DevOps Terraform Challenge

## Project Objective
This repository demonstrates provisioning Azure infrastructure using Terraform, following best practices for **reusable, secure, and maintainable Infrastructure as Code (IaC)**.

- Deploys a **VNET** using a reusable Terraform module
- Supports multiple environments: **dev** and **prod**
- Creates additional resources: Storage Account, Public IP, VM, Network Security Group, Key Vault
- Implements a **CI/CD pipeline** for automated deployments using GitHub Actions

---

## Folder Structure

opella-terraform-azure-infra/
│
├── modules/
│   └── vnet/                   # Reusable module for VNet + subnets
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── global/
│   └── backend/                # Terraform backend configuration
│       └── main.tf
│
├── environments/
│   ├── dev/                    # Development environment
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── outputs.tf
│   └── prod/                   # Production environment
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── outputs.tf
│
├── .github/
│   └── workflows/
│       └── terraform.yml       # GitHub Actions CI/CD pipeline
│
└── README.md                   # This file

---

## Backend Configuration
- Terraform state is stored in **Azure Storage Account** (remote backend)
- Ensures **state is shared**, **locked**, and **safe for team usage**

**Backend example (dev environment)**:
```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstatestorage1da"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}

## Module Usage Example

- The reusable VNet module can be invoked like this:

module "vnet" {
  source             = "../../modules/vnet"
  vnet_name          = "dev-vnet"
  address_space      = ["10.0.0.0/16"]
  subnets = {
    web = "10.0.1.0/24"
    app = "10.0.2.0/24"
  }
  resource_group_name = "rg-dev-eastus"
  tags = {
    environment = "dev"
    project     = "opella"
  }
}

- The module outputs subnet IDs and VNet ID for consumption by other resources.

## Deployment Instructions

1. Initialize Terraform

cd environments/dev
terraform init -reconfigure

2. Plan

terraform plan -var-file="terraform.tfvars" -out=tfplan

3. Apply

terraform apply tfplan


## Prod Env

cd environments/dev
terraform init -reconfigure

terraform plan -var-file="terraform.tfvars" -out=tfplan

terraform apply tfplan


## CI/CD Workflow (GitHub Actions)

This project includes a GitHub Actions pipeline to automate Terraform deployments.

**Workflow Steps**:
1. **Terraform Init** – Initialize backend and modules.
2. **Terraform Plan** – Generate execution plan, output saved as artifact.
3. **Approval (optional)** – Manual review before applying to prod.
4. **Terraform Apply** – Apply the plan to provision resources in Azure.
5. **Post-Deployment** – Optional notifications (Slack, email).

**Example GitHub Actions workflow file** (`.github/workflows/terraform.yml`):

```yaml
name: Terraform

on:
  push:
    branches:
      - main
      - dev

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
      - name: Terraform Init
        run: terraform init -reconfigure
      - name: Terraform Plan
        run: terraform plan -var-file="environments/dev/terraform.tfvars" -out=tfplan
      - name: Terraform Apply
        if: github.ref == 'refs/heads/main'
        run: terraform apply -auto-approve tfplan


## Key Variables

| Variable                                | Description                         |
| --------------------------------------- | ----------------------------------- |
| `rg_name`, `location`                   | Resource Group and region           |
| `vnet_name`, `address_space`, `subnets` | Networking configuration            |
| `project`, `tags`                       | Resource naming and tagging         |
| `admin_username`                        | VM administrator username           |
| `allowed_ssh_ip`                        | Restrict SSH access to specific IPs |


Note: - Sensitive values (VM passwords, keys) are stored in Azure Key Vault and retrieved dynamically.

## Outputs

| Output           | Description               |
| ---------------- | ------------------------- |
| `vnet_id`        | Virtual Network ID        |
| `subnet_ids`     | Map of subnet IDs         |
| `vm_id`          | Virtual Machine ID        |
| `vm_public_ip`   | Public IP address of VM   |
| `nsg_id`         | Network Security Group ID |
| `key_vault_name` | Key Vault name            |
| `key_vault_uri`  | Key Vault URI             |


## Best Practices Demonstrated

* Reusable VNet module for dev & prod environments

* Remote backend with state locking and sharing

* Secrets management using Key Vault

* SSH restricted to allowed IP addresses

* Consistent tagging for easy resource tracking

* Environment separation for dev vs prod


## [GitHub Repository URL]

https://github.com/yatamnani/opella-terraform-azure-infra.git

