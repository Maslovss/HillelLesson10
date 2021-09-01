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


resource "azurerm_resource_group" "lesson10" {
  name     = var.rgname
  location = var.location
}


resource "azurerm_virtual_network" "vnet-lesson10" {
  for_each = var.vnets

  
  location = var.location
  resource_group_name = azurerm_resource_group.lesson10.name
  
  name = each.key
  address_space = each.value.address

   dynamic "subnet" {
      for_each = each.value.subnet_address
      content {
        name = "subnet-${each.key}-${subnets.key}"
        address_prefix = subnets.value
      }
   }

  tags = {
    environment = "Study"
  }

}
