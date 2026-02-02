# Package the Python code into a ZIP
data "archive_file" "python_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../src"
  output_path = "${path.module}/function.zip"
  excludes    = ["__pycache__", ".venv"]
}

resource "azurerm_service_plan" "plan" {
  name                = "plan-ghostbuster"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "Y1" # Free/Consumption
}

resource "azurerm_linux_function_app" "func" {
  name                = "func-ghost-buster-cleaner"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  storage_account_name       = azurerm_storage_account.st.name
  storage_account_access_key = azurerm_storage_account.st.primary_access_key
  service_plan_id            = azurerm_service_plan.plan.id

  # Deploy the code automatically
  zip_deploy_file = data.archive_file.python_zip.output_path

  site_config {
    application_stack {
      python_version = "3.9"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "AZURE_SUBSCRIPTION_ID" = data.azurerm_subscription.current.subscription_id
    "AzureWebJobsFeatureFlags" = "EnableWorkerIndexing" # Required for Python V2
  }
}

# Grant the Function permission to scan the subscription
resource "azurerm_role_assignment" "rbac" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Reader" # Change to 'Contributor' if you want it to delete disks
  principal_id         = azurerm_linux_function_app.func.identity[0].principal_id
}