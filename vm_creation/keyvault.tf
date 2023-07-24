
data "azurerm_client_config" "current" {}


resource "random_string" "random" {
  length = 7  
  special = false  
  upper = false      # Adjust the length of the random string as needed
}


resource "azurerm_key_vault" "vault" {
  name                        = "abhishekvault-${random_string.random.result}"
  location                    = var.loc
  resource_group_name         = data.azurerm_resource_group.rg.name
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
      "List",
      "Delete",
      "Purge",
      "Recover"
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

resource "azurerm_key_vault_secret" "ssh-key" {
  depends_on = [ azurerm_key_vault.vault ]
  name         = "sshkey"
  value        = var.key
  key_vault_id = azurerm_key_vault.vault.id
}
