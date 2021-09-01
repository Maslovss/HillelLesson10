
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

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nics-ngs-association" {
    for_each  =  var.vms

    network_interface_id      =  lookup( azurerm_network_interface.nics ,  each.key).id
    network_security_group_id =  lookup( azurerm_network_security_group.ngs ,  each.key).id
}


####### DNS ##################


resource "azurerm_private_dns_zone" "private_dns" {
  name                = var.private_dns_name
  resource_group_name = azurerm_resource_group.rg.name
}


resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_links" {
  for_each  =  var.vnets
  
  name                  = each.key

  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns.name
  virtual_network_id    = lookup( azurerm_virtual_network.vnets , each.key).id
}

resource "azurerm_private_dns_a_record" "private_dns_a_records" {
  for_each  =  var.vms

  name                = each.value.computer_name
  zone_name           = azurerm_private_dns_zone.private_dns.name
  resource_group_name = azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [ lookup( azurerm_network_interface.nics , each.key ).private_ip_address ]
}
