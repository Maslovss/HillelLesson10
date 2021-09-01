
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-${var.rgname}"
  location = var.location
}


resource "azurerm_virtual_network" "vnets" {
  for_each            = var.vnets

  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  
  name                = "${var.prefix}-${each.key}"
  address_space       = each.value.cidr_blocks

   dynamic "subnet" {
      for_each = each.value.subnet_address
      content {
        name           = "${var.prefix}-subnet-${each.key}-${subnet.key}"
        address_prefix = subnet.value
      }
   }

  tags = var.tags

}

resource "azurerm_virtual_network_peering" "peering" {
  for_each = var.peering    
  name                      = "${var.prefix}-peer-${each.value.from}-to-${each.value.to}"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = lookup(azurerm_virtual_network.vnets , each.value.from).name
  remote_virtual_network_id = lookup(azurerm_virtual_network.vnets , each.value.to).id
}


# Create public IPs for all VMs with vms.public_ip = true
resource "azurerm_public_ip" "publicip" {
     for_each = { for k, v in var.vms : k => v if v.public_ip }

    name                         = "${var.prefix}-PublicIP"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.rg.name
    allocation_method            = "Dynamic"

    tags = var.tags
}

# Create network interface for all MVs
resource "azurerm_network_interface" "nics" {
    for_each  =  var.vms

    name                      = "${var.prefix}-nic-${each.key}"
    location                  = var.location
    resource_group_name       = azurerm_resource_group.rg.name

    ip_configuration {
        name                          = "${var.prefix}-nic-${each.key}-configuration"
        subnet_id                     =  tolist(lookup(azurerm_virtual_network.vnets , each.value.vnet).subnet)[ each.value.subnet_id ].id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = lookup( azurerm_public_ip.publicip , each.key , null )  == null ? null : lookup( azurerm_public_ip.publicip , each.key).id
    }

    tags = var.tags
}