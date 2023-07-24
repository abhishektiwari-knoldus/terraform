

resource "azurerm_subnet" "bastion" {
  depends_on           = [azurerm_virtual_network.vnet1]
  name                 = "AzureBastionSubnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.3.0/27"]
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