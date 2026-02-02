output "function_app_name" {
  description = "The name of the Ghost Buster Function App"
  value       = azurerm_linux_function_app.func.name
}

output "function_app_default_hostname" {
  description = "The default hostname of the Function App"
  value       = azurerm_linux_function_app.func.default_hostname
}

output "resource_group_name" {
  description = "The Resource Group where everything is deployed"
  value       = azurerm_resource_group.rg.name
}

output "managed_identity_principal_id" {
  description = "The Principal ID of the System Assigned Identity"
  value       = azurerm_linux_function_app.func.identity[0].principal_id
}