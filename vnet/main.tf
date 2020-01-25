provider "azurerm" {
  version = "=1.41.0"
}

resource "azurerm_resource_group" "azurerm_resource_group" {
  name     = "competencyTest_group"
  location = var.location
  tags     = var.tags
}

resource "azurerm_network_security_group" "azurerm_nsg" {
  name                = "competencyTest_NSG"
  location            = azurerm_resource_group.azurerm_resource_group.location
  resource_group_name = azurerm_resource_group.azurerm_resource_group.name
  tags                = var.tags
}

resource "azurerm_network_ddos_protection_plan" "azurerm_ddos_pp" {
  name                = "competencyTest_netDDoSpplan"
  location            = azurerm_resource_group.azurerm_resource_group.location
  resource_group_name = azurerm_resource_group.azurerm_resource_group.name
  tags                = var.tags
}

resource "azurerm_virtual_network" "azurerm_vnet" {
  name                = "competencyTest_VNet"
  location            = azurerm_resource_group.azurerm_resource_group.location
  resource_group_name = azurerm_resource_group.azurerm_resource_group.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
  tags                = var.tags

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.azurerm_ddos_pp.id
    enable = true
  }

  subnet {
    name           = "competencyTest_subnet"
    address_prefix = "10.0.1.0/24"
    security_group = azurerm_network_security_group.azurerm_nsg.id
  }
}

resource "azurerm_kubernetes_cluster" "azurerm_k8s_cluster" {
  name       = "competencyTest_aks"
  location   = azurerm_resource_group.azurerm_resource_group.location
  dns_prefix = "aks"
  resource_group_name = azurerm_resource_group.azurerm_resource_group.name
  kubernetes_version  = "1.15.b"

  agent_pool_profile {
    name           = "aks"
    count          = "3"
    vm_size        = "Standard_D2s_v3"
    os_type        = "Linux"
    vnet_subnet_id = azurerm_virtual_network.azurerm_vnet.subnet.id
  }

  service_principal {
    client_id     = var.CID
    client_secret = var.CS
  }

  network_profile {
    network_plugin = "azure"
  }
}
