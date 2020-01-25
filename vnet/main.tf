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

  security_rule {
    name                       = "HTTPS"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
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
  address_space       = ["10.1.0.0/16"]
  tags                = var.tags

  ddos_protection_plan {
    id     = azurerm_network_ddos_protection_plan.azurerm_ddos_pp.id
    enable = true
  }

}

resource "azurerm_subnet" "azurerm_subnet" {
  name                      = "acompetencyTest_subnet"
  resource_group_name       = azurerm_resource_group.azurerm_resource_group.name
  address_prefix            = "10.1.1.0/24"
  virtual_network_name      = azurerm_virtual_network.azurerm_vnet.name

}

resource "azurerm_subnet_network_security_group_association" "azurerm_subnet_NSG" {
  subnet_id                 = azurerm_subnet.azurerm_subnet.id
  network_security_group_id = azurerm_network_security_group.azurerm_nsg.id
}

resource "azurerm_kubernetes_cluster" "azurerm_k8s_cluster" {
  name       = "competencyTest_aks"
  location   = azurerm_resource_group.azurerm_resource_group.location
  dns_prefix = "aks"
  resource_group_name = azurerm_resource_group.azurerm_resource_group.name
  kubernetes_version  = var.aksVersion

  agent_pool_profile {
    name           = "aks"
    count          = "3"
    vm_size        = "Standard_D2s_v3"
    os_type        = "Linux"
    vnet_subnet_id = azurerm_subnet.azurerm_subnet.id
  }

  service_principal {
    client_id     = var.CID
    client_secret = var.CS
  }

  network_profile {
    network_plugin = "azure"
  }
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.azurerm_k8s_cluster.kube_config_raw
}