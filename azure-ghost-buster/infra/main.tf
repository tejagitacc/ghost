provider "azurerm" {
  features {}
}

data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "rg-ghostbuster-prod"
  location = "East US"
}

resource "azurerm_storage_account" "st" {
  name                     = "stghostbusterlogic"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}