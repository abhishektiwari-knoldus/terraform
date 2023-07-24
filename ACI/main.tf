
resource "azurerm_resource_group" "rg" {
  name     = var.rgname
  location = var.location
}

resource "azurerm_container_group" "container" {
  name                = var.container_group_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = var.iptype
  os_type             = var.ostype
  restart_policy      = var.restart_policy

  container {
    name   = var.container_name
    image  = var.image
    cpu    = var.cpu
    memory = var.memory

    ports {
      port     = var.port
      protocol = var.prot
    }
  }
}