provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_sync" "example" {
  name                = "example-ss"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}

resource "azurerm_storage_sync_group" "example" {
  name            = "example-ss-group"
  storage_sync_id = azurerm_storage_sync.example.id
}

resource "azurerm_storage_account" "example" {
  name                     = "examplegiwu4hr8734"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "example" {
  name                 = "example-share"
  storage_account_name = azurerm_storage_account.example.name
  quota                = 50
  acl {
    id = "GhostedRecall"
    access_policy {
      permissions = "r"
    }
  }
}

resource "azurerm_storage_sync_cloud_endpoint" "example" {
  name                  = "example-ss-ce"
  storage_sync_group_id = azurerm_storage_sync_group.example.id
  file_share_name       = azurerm_storage_share.example.name
  storage_account_id    = azurerm_storage_account.example.id
}

