variable "location" {
  default = "South Central US"
}

variable "resource_group_name" {
  default = "rg-gold-image"
}

variable "admin_username" {
  default = "imageadmin"
}

variable "admin_password" {
  sensitive = true
}
