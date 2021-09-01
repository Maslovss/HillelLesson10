

# output "VMS" {
#     value = {for k, v in azurerm_virtual_network.vnets : k => tolist(v.subnet)[0] }
# }


output "tls_private_key" {
    value = {for k, v in  tls_private_key.ssh : k => v.private_key_pem }
    sensitive  = true
}

output "public_ips" {
    value = {for k, v in  azurerm_public_ip.publicip : k => v.ip_address }
}
