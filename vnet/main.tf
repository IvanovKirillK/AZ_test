provider "azurerm" {
  version = "=1.22.0"
}

resource "azurerm_resource_group" "azurerm_resource_group" {
  name     = "terraform-group"
  location = "${var.location}"
  tags     = "${var.tags}"
}