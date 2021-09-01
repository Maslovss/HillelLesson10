location = "eastus"
rgname = "lesson10rg"

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

peering = {
    v1to2 = {
        from = "vnet1"
        to   = "vnet2"
    },
    v2to1 = {
        from = "vnet2"
        to   = "vnet1"
    }
}


tags = {
    Environment = "development"
    Accounting = "Hillel"
    Lesson = "Lesson10"
    Owner = "maslovss@gmail.com"
    Purpose = "Study"
}
