location = "eastus"
rgname = "lesson10"

vnets = { 
    vnet1 = {
        cidr_blocks = [ "10.10.0.0/20" ]
        subnet_address = [ "10.10.0.0/24" , "10.10.1.0/24" , "10.10.2.0/24" ]  
    },
    vnet2 = {
        cidr_blocks = [ "10.10.16.0/20" ] 
        subnet_address = [ "10.10.16.0/24" , "10.10.17.0/24" ]
    }
}
