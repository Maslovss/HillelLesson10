

resource "azurerm_network_security_group" "ngs" {

#For all VMs will created ngs( for all variable vms.nsg_rules ) 
#For example f vm.ngs_rules = [ "ssh" , "icmp" , "http" ]  TF will create ngs with name {prefix}-ngs-ssh-icmp-http
#and apply appropriate rules from variable nsgrules_definitions 

  for_each            = var.vms
  name                = "${var.prefix}-ngs-${join("-",each.value.nsg_rules)}"

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name


  dynamic "security_rule" {
      for_each = each.value.nsg_rules
      content {
        name           = "${var.prefix}-ngs-rule-${security_rule.value}"
        priority                   = lookup( var.nsgrules_definitions ,  security_rule.value).priority
        direction                  = lookup( var.nsgrules_definitions ,  security_rule.value).direction
        access                     = lookup( var.nsgrules_definitions ,  security_rule.value).access
        protocol                   = lookup( var.nsgrules_definitions ,  security_rule.value).protocol
        source_port_range          = lookup( var.nsgrules_definitions ,  security_rule.value).source_port_range
        destination_port_range     = lookup( var.nsgrules_definitions ,  security_rule.value).destination_port_range
        source_address_prefix      = lookup( var.nsgrules_definitions ,  security_rule.value).source_address_prefix
        destination_address_prefix = lookup( var.nsgrules_definitions ,  security_rule.value).destination_address_prefix
      }
   }

  tags = var.tags

}


resource "tls_private_key" "ssh" {
  for_each     = var.vms    

  algorithm    = "RSA"
  rsa_bits     = 4096
}
