
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
      cidr_blocks = [ "10.10.0.0/16" ]
      subnet_address = [ "10.10.0.0/24" ]
    }
  }

  description = "Vnets definition list"
}

variable "tags" {
  default = {
    Environment = "Hillel"
    Owner = "maslovss@gmail.com"
    Purpose = "Study"
  }
}