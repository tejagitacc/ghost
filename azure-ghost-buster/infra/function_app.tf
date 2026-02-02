# The App Service Plan (Serverless/Consumption)
resource "azurerm_service_plan" "plan" {
  name                = "plan-${var.project_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "Y1" 
}

# The Linux Function App
resource "azurerm_linux_function_app" "func" {
  name                = "func-${var.project_name}-cleaner"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  storage_account_name       = azurerm_storage_account.st.name
  storage_account_access_key = azurerm_storage_account.st.primary_access_key
  service_plan_id            = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      python_version = "3.9" # Matches your local Python version
    }
  }

  # This is the "Security Pro" move: No passwords, just Identity
  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "AZURE_SUBSCRIPTION_ID" = data.azurerm_subscription.current.subscription_id
    "ENABLE_AUTO_DELETE"    = "false" # Safety toggle
  }
}

# Granting the Function permissions to the Subscription
resource "azurerm_role_assignment" "rbac" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_linux_function_app.func.identity[0].principal_id
}