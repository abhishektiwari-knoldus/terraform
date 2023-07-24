data "azurerm_resource_group" "rg" {
  name = var.rgname
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "vpn-vnet1"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.rgname
}

resource "azurerm_subnet" "subnetg" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.rgname
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.1.0/27"]
}
resource "azurerm_subnet" "subnetgvm" {
  name                 = "vmSubnet1"
  resource_group_name  = var.rgname
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_virtual_network" "vnet2" {
  name                = "vpn-vnet2"
  address_space       = ["20.0.0.0/16"]
  location            = var.location
  resource_group_name = var.rgname
}

resource "azurerm_subnet" "subnetg1" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.rgname
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = ["20.0.1.0/27"]
}
resource "azurerm_subnet" "subnetgvm1" {
  name                 = "vmSubnet2"
  resource_group_name  = var.rgname
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = ["20.0.2.0/24"]
}

resource "azurerm_public_ip" "pub-ip1" {
  name                = "vpn-public-ip1"
  location            = var.location
  resource_group_name = var.rgname
  allocation_method   = "Dynamic"
}

resource "azurerm_public_ip" "pub-ip2" {
  name                = "vpn-public-ip2"
  location            = var.location
  resource_group_name = var.rgname
  allocation_method   = "Dynamic"
}
resource "azurerm_virtual_network_gateway" "gateway1" {
  name                = "gateway1"
  location            = var.location
  resource_group_name = var.rgname
  type                = var.type
  vpn_type            = var.vpn-type
  sku                 = var.gatewaySKU
  ip_configuration {
    subnet_id            = azurerm_subnet.subnetg.id
    public_ip_address_id = azurerm_public_ip.pub-ip1.id
  }
}

resource "azurerm_virtual_network_gateway" "gateway2" {
  name                = "gateway2"
  location            = var.location
  resource_group_name = var.rgname
  type                = var.type
  vpn_type            = var.vpn-type
  sku                 = var.gatewaySKU
  ip_configuration {
    subnet_id            = azurerm_subnet.subnetg1.id
    public_ip_address_id = azurerm_public_ip.pub-ip2.id
  }
}

#connection for gateways

resource "azurerm_virtual_network_gateway_connection" "conn1" {
  name                            = "conn1"
  resource_group_name             = var.rgname
  location                        = var.location
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.gateway1.id
  type                            = "Vnet2Vnet"
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.gateway2.id
  shared_key                      = var.sharedKey
}

resource "azurerm_virtual_network_gateway_connection" "conn2" {
  name                            = "conn2"
  resource_group_name             = var.rgname
  location                        = var.location
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.gateway2.id
  type                            = "Vnet2Vnet"
  peer_virtual_network_gateway_id = azurerm_virtual_network_gateway.gateway1.id
  shared_key                      = var.sharedKey
}


