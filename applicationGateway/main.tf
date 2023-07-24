
data "azurerm_resource_group" "rg" {
    name = "Abhishek-rg1"
  
}

resource "azurerm_virtual_network" "vnet" {
    name = "vnet_application_gateway"
    resource_group_name =  data.azurerm_resource_group.rg.name
    location = data.azurerm_resource_group.rg.location
    address_space = [ "10.0.0.0/16" ]
    depends_on = [ data.azurerm_resource_group.rg ]
    
}


resource "azurerm_public_ip" "gatwayip" {
  name                = "gateway-ip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
   sku                 = "Standard"
}
resource "azurerm_subnet" "vm-subnet" {
  name                 = "vmSubnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "app-subnet" {
  name                 = "appSubnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}


resource "azurerm_network_interface" "nic1" {
  name                = "nic-vm-01"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_interface" "nic2" {
  name                = "nic-vm-02"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vm-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_security_group" "nsg1" {
  name                = "nsg1"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name


  security_rule {
    name                       = "All"
    priority                   = 201
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  


}
resource "azurerm_network_security_group" "nsg2" {
  name                = "nsg2"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name


  security_rule {
    name                       = "All"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  


}
resource "azurerm_network_interface_security_group_association" "nsg_nic" {

  network_interface_id      = azurerm_network_interface.nic1.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
  


}
resource "azurerm_network_interface_security_group_association" "nsg_nic1" {

  network_interface_id      = azurerm_network_interface.nic2.id
  network_security_group_id = azurerm_network_security_group.nsg2.id
  


}

resource "azurerm_linux_virtual_machine" "vm-01" {
  name                = "VM01_AG"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                  = "Standard_DS1_v2"
  
  
  network_interface_ids = [
    azurerm_network_interface.nic1.id,
  ]
  

  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  disable_password_authentication = false
  admin_password = "akash@@12345"

  os_disk {
    name = "osdist1"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }



source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
resource "azurerm_linux_virtual_machine" "vm-02" {
  name                = "VM02_AG"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  size                  = "Standard_DS1_v2"
  
  
  network_interface_ids = [
    azurerm_network_interface.nic2.id,
  ]
  

  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  disable_password_authentication = false
  admin_password = "akash@@12345"

  os_disk {
    name = "osdist2"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }


source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
resource "azurerm_application_gateway" "network" {
  name                = "appgateway"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "gateway-ip-configuration"
    subnet_id = azurerm_subnet.app-subnet.id
  }

  frontend_port {
    name = "frontEnd-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontEndIP"
    public_ip_address_id = azurerm_public_ip.gatwayip.id
  }

  backend_address_pool {
    name = "backEndPool"
    ip_addresses = [
        "${azurerm_network_interface.nic1.private_ip_address}",
        
        "${azurerm_network_interface.nic2.private_ip_address}"

        ]
  }
 

  backend_http_settings {
    name                  = "httpsetting"
    cookie_based_affinity = "Disabled"
    path = ""
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }


  http_listener {
    name                           = "listner"
    frontend_ip_configuration_name = "frontEndIP"
    frontend_port_name             = "frontEnd-port"
    protocol                       = "Http"
  }

  
  request_routing_rule {
    name                       = "rule1"
    rule_type                  = "Basic"
    priority                   = 2
    http_listener_name         = "listner"
    backend_address_pool_name  = "pool"
    backend_http_settings_name = "httpsetting"
  }
}

