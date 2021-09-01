

output "VMS" {
    value = {for k, v in azurerm_virtual_network.vnets : k => tolist(v.subnet)[0] }
}