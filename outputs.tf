

output "VMS" {
    value = {for k, v in azurerm_virtual_network.vnets : k => element(v.subnet,0) }
}