
variable "location" {
    description = "Location of the network"
    default     = "eastus"
}

variable "rgname" {
    description = "Name of resourse group"
    default     = "my-rg"
}

variable "environment_name" {
  type = string
  default = "lesson10-env"
}



variable "vnets" {

  default = {  
    vnet1 = { 
      address = "my-vnet"
      name = "10.10.0.0/16"
      subnet_address = [ "10.10.0.0/24" ]
    }
  }

  description = "Vnets definition list"
}
