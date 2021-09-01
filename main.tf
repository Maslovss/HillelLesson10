terraform {
  required_version = ">=0.12"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "lesson10rg" {
  name     = var.rgname
  location = var.location
}


resource "azurerm_virtual_network" "lesson10vnets" {
  for_each            = var.vnets

  location            = var.location
  resource_group_name = azurerm_resource_group.lesson10rg.name
  
  name                = each.key
  address_space       = each.value.cidr_blocks

   dynamic "subnet" {
      for_each = each.value.subnet_address
      content {
        name           = "subnet-${each.key}-${subnet.key}"
        address_prefix = subnet.value
      }
   }

  tags = var.tags

}

resource "azurerm_virtual_network_peering" "lesson10peering" {
  for_each = var.peering    
  name                      = "peer-${each.value.from}-to-${each.value.to}"
  resource_group_name       = azurerm_resource_group.lesson10rg.name
  virtual_network_name      = lookup(azurerm_virtual_network.lesson10vnets , each.value.from).name
  remote_virtual_network_id = lookup(azurerm_virtual_network.lesson10vnets , each.value.to).id
}

