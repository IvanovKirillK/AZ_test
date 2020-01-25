provider "azurerm" {
  version = "=1.41.0"
}

resource "azurerm_resource_group" "azurerm_resource_group" {
  name     = "competencyTest_group"
  location = var.location
  tags     = var.tags
}