terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.32.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  ssh_pub_key_file = "~/.ssh/id_rsa.pub"
  location         = "West Europe"
  admin_username   = "iacadmin"
}

data "cloudinit_config" "config" {
  part {
    content_type = "text/x-shellscript"
    filename     = "install.sh"
    content      = templatefile("../scripts/install.sh", { hostname = "webserver02" })
  }
}

resource "azurerm_resource_group" "azure_iac_resourcegroup" {
  name     = "azure-iac-rg"
  location = local.location
}

resource "azurerm_virtual_network" "azure_iac_virtual_network" {
  name                = "iac-network"
  address_space       = ["10.0.0.0/16"]
  location            = local.location
  resource_group_name = azurerm_resource_group.azure_iac_resourcegroup.name
}

resource "azurerm_subnet" "azure_iac_subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.azure_iac_resourcegroup.name
  virtual_network_name = azurerm_virtual_network.azure_iac_virtual_network.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "azure_azure_iac_public_ip" {
  name                = "azure_iac_public_ip"
  resource_group_name = azurerm_resource_group.azure_iac_resourcegroup.name
  location            = local.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "azure_iac_nic" {
  name                = "azure_iac-nic"
  location            = local.location
  resource_group_name = azurerm_resource_group.azure_iac_resourcegroup.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.azure_iac_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.azure_azure_iac_public_ip.id
  }
}

resource "azurerm_network_security_group" "azure_iac_nsg" {
  name                = "azure_iac_nsg"
  location            = local.location
  resource_group_name = azurerm_resource_group.azure_iac_resourcegroup.name

  security_rule {
    name                       = "allow_azure_iac_sg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allow_ssh_sg"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.azure_iac_nic.id
  network_security_group_id = azurerm_network_security_group.azure_iac_nsg.id
}

resource "azurerm_linux_virtual_machine" "azure_web_server" {
  name                = "webserver02"
  resource_group_name = azurerm_resource_group.azure_iac_resourcegroup.name
  location            = local.location
  size                = "Standard_B1s"
  admin_username      = local.admin_username
  custom_data         = data.cloudinit_config.config.rendered


  network_interface_ids = [
    azurerm_network_interface.azure_iac_nic.id,
  ]

  source_image_reference {
    offer     = "0001-com-ubuntu-server-focal"
    publisher = "Canonical"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  admin_ssh_key {
    username   = local.admin_username
    public_key = file(local.ssh_pub_key_file)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

}

output "azure_webserver02_public_ip" {
  value = <<AZURE
  The Azure webserver has been deployed.
  SSH details: ${local.admin_username}@${azurerm_linux_virtual_machine.azure_web_server.public_ip_address}
  Webserver details: http://${azurerm_linux_virtual_machine.azure_web_server.public_ip_address}
  AZURE
}
