resource "azurerm_virtual_network" "lb-vnet" {
  name                = "lb-vnet"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = ["10.20.0.0/16"]
}

resource "azurerm_subnet" "LB-Subnet" {
  name                 = "LB-Subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.lb-vnet.name
  address_prefixes     = ["10.20.10.0/24"]
}




resource "azurerm_public_ip" "lb_public_ip" {
  name                = "lb-public-ip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_lb" "MyLB" {
  name                = "MyLB"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                 = "MyLBFrontEndIP"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
}


resource "azurerm_lb_backend_address_pool" "MyBackendPool" {
  loadbalancer_id = azurerm_lb.MyLB.id
  name            = "MyBackendPool"
}


resource "azurerm_lb_probe" "ssh-inbound-probe" {
  loadbalancer_id = azurerm_lb.MyLB.id
  name            = "ssh-inbound-probe"
  protocol        = "Tcp"
  port            = 80
}

resource "azurerm_lb_rule" "MyLB_Rule" {
  loadbalancer_id                = azurerm_lb.MyLB.id
  name                           = "ssh-inbound-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "MyLBFrontEndIP"
  probe_id                       = azurerm_lb_probe.ssh-inbound-probe.id
  backend_address_pool_ids       = ["${azurerm_lb_backend_address_pool.MyBackendPool.id}"]

}



