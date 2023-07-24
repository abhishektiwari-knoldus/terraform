resource "azurerm_resource_group" "rg" {
  name     = "Abhishek-rg-Function"
  location = "eastasia"
}

resource "azurerm_storage_account" "sa" {
  name                     = "abhishektfbhef78"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = var.tier
  account_replication_type = var.replication
}

resource "azurerm_app_service_plan" "appservice" {
  name                = "service-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "app" {
  name                       = "functionshamar5640d"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  app_service_plan_id        = azurerm_app_service_plan.appservice.id
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
  os_type                    = "linux"
  version                    = "~4"

    app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "node"
  }
}