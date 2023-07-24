
provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "example" {
  name     = "Abhishek-rg1"
}

resource "azurerm_virtual_network" "example-1" {
  name                = "peternetwork1"
  resource_group_name = data.azurerm_resource_group.example.name
  address_space       = ["10.10.0.0/16"]
  location            = data.azurerm_resource_group.example.location
}
resource "azurerm_subnet" "subnet-1" {
  name = "1-subnet"
  resource_group_name = data.azurerm_resource_group.example.name
  address_prefixes = ["10.10.1.0/24"]
  virtual_network_name = azurerm_virtual_network.example-1.name

}

resource "azurerm_virtual_network" "example-2" {
  name                = "peternetwork2"
  resource_group_name = data.azurerm_resource_group.example.name
  address_space       = ["10.20.0.0/16"]
  location            = data.azurerm_resource_group.example.location
}

resource "azurerm_subnet" "subnet-2" {
  name = "2-subnet"
  resource_group_name = data.azurerm_resource_group.example.name
  address_prefixes = ["10.20.0.0/24"]
  virtual_network_name = azurerm_virtual_network.example-2.name

}

# resource "azurerm_virtual_network_peering" "example-1" {
#   name                      = "peer1to2"
#   resource_group_name       = data.azurerm_resource_group.example.name
#   virtual_network_name      = azurerm_virtual_network.example-1.name
#   remote_virtual_network_id = azurerm_virtual_network.example-2.id
# }

# resource "azurerm_virtual_network_peering" "example-2" {
#   name                      = "peer2to1"
#   resource_group_name       = data.azurerm_resource_group.example.name
#   virtual_network_name      = azurerm_virtual_network.example-2.name
#   remote_virtual_network_id = azurerm_virtual_network.example-1.id
# }