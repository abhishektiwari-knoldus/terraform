resource "azurerm_resource_group" "logic-apprg" {
  name     = var.rgname
  location = var.loc
}

resource "azurerm_storage_account" "sa" {
  name                     = var.saname
  resource_group_name      = azurerm_resource_group.logic-apprg.name
  location                 = azurerm_resource_group.logic-apprg.location
  account_tier             = var.tier
  account_replication_type = var.replication
}

resource "azurerm_app_service_plan" "example" {
  name                = "service-plan"
  location            = azurerm_resource_group.logic-apprg.location
  resource_group_name = azurerm_resource_group.logic-apprg.name
  kind                = "elastic"


  sku {
    tier = "WorkflowStandard"
    size = "WS1"
  }
}

resource "azurerm_logic_app_standard" "example" {
  name                       = var.appname
  location                   = azurerm_resource_group.logic-apprg.location
  resource_group_name        = azurerm_resource_group.logic-apprg.name
  app_service_plan_id        = azurerm_app_service_plan.example.id
  storage_account_name       = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
  

}