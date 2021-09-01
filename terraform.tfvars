
prefix = "lesson10"
location = "eastus"
rgname = "rg"

vnets = { 
    vnet1 = {
        cidr_blocks = [ "10.10.0.0/20" ]
        subnet_address = [ "10.10.0.0/24" , "10.10.1.0/24" , "10.10.2.0/24" ]  
    }
    vnet2 = {
        cidr_blocks = [ "10.10.16.0/20" ] 
        subnet_address = [ "10.10.16.0/24" , "10.10.17.0/24" ]
    }
}

peering = {
    v1to2 = {
        from = "vnet1"
        to   = "vnet2"
    }
    v2to1 = {
        from = "vnet2"
        to   = "vnet1"
    }
}

vms = {
    vm1 = {
        size      = "Standard_DS1_v2"

        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"        
        
        computer_name = "vm1-host"
        admin_username = "ec2-user"

        vnet      = "vnet1"
        subnet_id = 0
        public_ip = true 
        nsg_rules  = [ "ssh" , "icmp" ]
    }
    vm2 = {
        size      = "Standard_DS1_v2"

        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"        
        
        computer_name = "vm2-host"
        admin_username = "ec2-user"

        vnet      = "vnet2"
        subnet_id = 1
        public_ip = false
        nsg_rules  = [ "icmp" ]
    }
}

tags = {
    Environment = "development"
    Accounting = "Hillel"
    Lesson = "Lesson10"
    Owner = "maslovss@gmail.com"
    Purpose = "Study"
    Terraform = "yes"
}



########### Constant variables ##################

nsgrules_definitions = {   
    ssh = {
      name                       = "ssh"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range    = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    icmp = {
      name                       = "icmp"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Icmp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    http = {
      name                       = "http"
      priority                   = 102
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range    = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    } 
    https = {
      name                       = "https"
      priority                   = 103
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range    = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }     
  }