
variable "prefix" {
  type = string
  default = "tf"
}

variable "location" {
    description = "Location of the network"
    default     = "eastus"
}

variable "rgname" {
    description = "Name of resourse group"
    default     = "my-rg"
}

variable "private_dns_name" {
  type = string
  default = "azure.local"
}


variable "vnets" {

  default = {  
    vnet1 = { 
      cidr_blocks = [ "10.10.0.0/16" ]
      subnet_address = [ "10.10.0.0/24" ]
    }
  }

  description = "Vnets definition list"
}

variable "vms" {
  type = map(object({

       size      = string

        publisher = string
        offer     = string
        sku       = string
        version   = string        
        
        computer_name = string
        admin_username = string   

        vnet      = string
        subnet_id = number
        public_ip = bool
        nsg_rules  = list(string)

  }))  

  description = "VMs definition list, subnet_id starts from 0"
}



variable "tags" {
  default = {
    Environment = "development"
    Accounting = "Hillel"
    Lesson = "Lesson10"
    Owner = "maslovss@gmail.com"
    Purpose = "Study"
    Terraform = "yes"
  }
}

variable "peering" {
  type = map(object({
    from = string
    to = string
  }))
  
}


variable "nsgrules_definitions" {
  type = map(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string 
      source_address_prefix      = string
      destination_address_prefix = string
  }))
  description = "Definition of rules, key using in vms.nsg_rules"  
}