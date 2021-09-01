
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



variable "vnet1" {
  type = object({
    name    = string
    address = string
    subnet_address = string
  })

  default = {
    address = "Vnet1-lesson10"
    name = "10.10.0.0/16"
    subnet_address = "10.10.0.0/24"
  }

  sensitive = true
  description = "Vnet1 settings"
}

variable "vnet2" {
  type = object({
    name    = string
    address = string
    subnet_address = string
  })

  default = {
    address = "Vnet2-lesson10"
    name = "10.10.1.0/16"
    subnet_address = "10.10.1.0/24"
  }
  
  description = "Vnet2 settings"
}

