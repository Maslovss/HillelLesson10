

resource "azurerm_network_security_group" "ngs" {
  for_each            = var.vms
  name                = "${var.prefix}-ngs-${join("-",each.value.nsg_rules)}"

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name


  dynamic "security_rule" {
      for_each = each.value.nsg_rules
      content {
        name           = "${var.prefix}-ngs-rule-${security_rule.value.name}"
        priority                   = lookup( nsgrules_definitions ,  security_rule.value).priority
        direction                  = lookup( nsgrules_definitions ,  security_rule.value).direction
        access                     = lookup( nsgrules_definitions ,  security_rule.value).access
        protocol                   = lookup( nsgrules_definitions ,  security_rule.value).protocol
        source_port_range          = lookup( nsgrules_definitions ,  security_rule.value).source_port_range
        destination_port_range     = lookup( nsgrules_definitions ,  security_rule.value).destination_port_range
        source_address_prefix      = lookup( nsgrules_definitions ,  security_rule.value).source_address_prefix
        destination_address_prefix = lookup( nsgrules_definitions ,  security_rule.value).destination_address_prefix
      }
   }

  tags = var.tags

}