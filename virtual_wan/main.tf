data "azurerm_resource_group" "rg" {
  name     = "Abhishek-rg1"
}

resource "azurerm_virtual_wan" "wan" {
  name                = "rg-vwan"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
}

resource "azurerm_virtual_hub" "hub1" {
  name                = "rg-vhub1"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  virtual_wan_id      = azurerm_virtual_wan.wan.id
  address_prefix      = "10.0.0.0/24"
}

resource "azurerm_virtual_hub" "hub2" {
  name                = "rg-vhub2"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  virtual_wan_id      = azurerm_virtual_wan.wan.id
  address_prefix      = "20.0.0.0/24"
}

#vnet

resource "azurerm_virtual_network" "vnet1" {
  name                = "vpn-vnet1"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnetgvm" {
  name                 = "vmSubnet1"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_virtual_network" "vnet2" {
  name                = "vpn-vnet2"
  address_space       = ["20.0.0.0/16"]
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnetgvm1" {
  name                 = "vmSubnet2"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = ["20.0.1.0/24"]
}

#connection

# Virtual WAN Connections
resource "azurerm_virtual_hub_connection" "connection1" {
  name                      = "conn1"
  virtual_hub_id            = azurerm_virtual_hub.hub1.id
  remote_virtual_network_id = azurerm_virtual_network.vnet1.id
}
resource "azurerm_virtual_hub_connection" "connection2" {
  name                      = "conn2"
  virtual_hub_id            = azurerm_virtual_hub.hub2.id
  remote_virtual_network_id = azurerm_virtual_network.vnet2.id
}

#bastion



resource "azurerm_subnet" "bastion" {
  depends_on           = [azurerm_virtual_network.vnet1]
  name                 = "AzureBastionSubnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.2.0/27"]
}

resource "azurerm_public_ip" "bastionIP" {
  name                = "bastion-ip"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastionHost" {
  depends_on          = [azurerm_subnet.bastion]
  name                = "bastion-vpn"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion.id
    public_ip_address_id = azurerm_public_ip.bastionIP.id
  }
}





