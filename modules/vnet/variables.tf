variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "address_space" {
  description = "Address space for VNet"
  type        = list(string)

  validation {
    condition     = length(var.address_space) > 0
    error_message = "Address space must not be empty."
  }
}

variable "subnets" {
  description = "Map of subnet names and CIDR ranges"
  type        = map(string)
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}

