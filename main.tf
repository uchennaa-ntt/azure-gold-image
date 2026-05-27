resource "azurerm_resource_group" "gold_rg" {
  name     = var.gold_rg_name
  location = var.location
}

# -----------------------------
# Reference Existing VNet
# -----------------------------
data "azurerm_virtual_network" "existing_vnet" {
  name                = var.existing_vnet_name
  resource_group_name = var.network_rg_name
}

data "azurerm_subnet" "existing_subnet" {
  name                 = var.existing_subnet_name
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name  = var.network_rg_name
}

# -----------------------------
# NIC using existing subnet
# -----------------------------
resource "azurerm_network_interface" "nic" {
  name                = "gold-image-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.gold_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.existing_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# -----------------------------
# Windows Gold Image Build VM
# -----------------------------
resource "azurerm_windows_virtual_machine" "vm" {
  name                = "win2022-gold-build"
  location            = var.location
  resource_group_name = azurerm_resource_group.gold_rg.name
  size                = "Standard_D2s_v3"
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter"
    version   = "latest"
  }
}

# -----------------------------
# Azure Compute Gallery
# -----------------------------
resource "azurerm_shared_image_gallery" "gallery" {
  name                = "goldImageGalpcm"
  resource_group_name = azurerm_resource_group.gold_rg.name
  location            = var.location
}

resource "azurerm_shared_image" "windows_image" {
  name                = "Win2022-Gold"
  gallery_name        = azurerm_shared_image_gallery.gallery.name
  resource_group_name = azurerm_resource_group.gold_rg.name
  location            = var.location
  os_type             = "Windows"

  identifier {
    publisher = "Company"
    offer     = "WindowsServer"
    sku       = "2022-Gold"
  }
}
