# Create a virtual network
resource "azurerm_virtual_network" "vnet-1" {
  name                = "my-vnet01"
  address_space       = ["172.1.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create a subnet within the virtual network
resource "azurerm_subnet" "subnet-1" {
  name                 = "my-subnet01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet-1.name
  address_prefixes     = ["172.1.0.0/24"]

}


resource "azurerm_virtual_network" "vnet-2" {
  name                = "my-vent02"
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
}
resource "azurerm_subnet" "subnet-2" {
  name = "my-subnet02"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet-2.name
  address_prefixes = ["10.0.0.0/24"]
}
