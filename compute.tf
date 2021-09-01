
# Create virtual machine
resource "azurerm_linux_virtual_machine" "vms" {
    for_each  =  var.vms    

    name                  = each.key
    location              = var.location
    resource_group_name   = azurerm_resource_group.rg
    network_interface_ids = [ lookup(azurerm_network_interface.nics , each.key ) ]
    size                  = each.value.size

    os_disk {
        name              = "myOsDisk-${each.key}"
        caching           = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {

        publisher = each.value.publisher
        offer     = each.value.offer
        sku       = each.value.sku
        version   = each.value.version
    }

    computer_name  = each.value.computer_name
    admin_username = each.value.admin_username
    disable_password_authentication = true

    admin_ssh_key {
        username       = each.value.admin_username
        public_key     = lookup(tls_private_key.ssh , each.key).public_key_openssh
    }

    # boot_diagnostics {
    #     storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    # }

    tags = var.tags
}