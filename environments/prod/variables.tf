variable "rg_name" {
  description = "Resource Group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_name" {
  description = "Virtual Network name"
  type        = string
}

variable "address_space" {
  description = "VNet address space"
  type        = list(string)

  validation {
    condition     = length(var.address_space) > 0
    error_message = "Address space must not be empty."
  }
}

variable "subnets" {
  description = "Subnet map (name = CIDR)"
  type        = map(string)
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)

  default = {
    environment = "Prod"
  }
}

variable "project" {
  description = "Project name prefix"
  type        = string
}

variable "admin_username" {
  description = "VM admin username"
  type        = string
}

# SSH restriction (VERY IMPORTANT)
variable "allowed_ssh_ip" {
  description = "Allowed IP address for SSH access (use YOUR_IP/32)"
  type        = string

  validation {
    condition     = length(var.allowed_ssh_ip) > 0
    error_message = "SSH IP must not be empty."
  }
}

# Public IP config
variable "public_ip_allocation_method" {
  description = "Public IP allocation method (Dynamic or Static)"
  type        = string
  default     = "Dynamic"

  validation {
    condition     = contains(["Dynamic", "Static"], var.public_ip_allocation_method)
    error_message = "Allowed values: Dynamic or Static."
  }
}

