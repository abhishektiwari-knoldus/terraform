
resource "azurerm_resource_group" "rg" {
  name     = "key-vault-abhishek"
  location = "eastasia"
}

data "azurerm_client_config" "current" {}


resource "azurerm_key_vault" "vault" {
  name                        = "abhishekvault9481"
  location                    = "eastasia"
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = true

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
      "list",
      "delete",
      "purge",
      "recover"
    ]

    storage_permissions = [
      "Get",
    ]
  }
}