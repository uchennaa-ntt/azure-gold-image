variable "location" {
  default = "South Central US"
}

variable "gold_rg_name" {
  default = "rg-gold-image"
}

variable "network_rg_name" {
  default = "rg-aks-monitoring"
}

variable "existing_vnet_name" {
  default = "NTTLAB"
}

variable "existing_subnet_name" {
  default = "NTTLAB-snet-web"
}

variable "admin_username" {
  default = "imagedmin"
}

variable "admin_password" {
  sensitive = true
}
