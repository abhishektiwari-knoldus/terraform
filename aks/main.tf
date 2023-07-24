
resource "azurerm_resource_group" "rg" {
  name     = var.rgname
  location = var.loc
}


# Create an AKS cluster
resource "azurerm_kubernetes_cluster" "cluster" {
  name                = var.clustername
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dnsprefix


  identity {
    type = var.identity #systemassigned
  }
  
  default_node_pool {
    name                 = "default"
    node_count           = 1
    vm_size              = "Standard_DS2_v2"
    vnet_subnet_id       = azurerm_subnet.subnet-1.id
    enable_auto_scaling  = true
    min_count            = 1
    max_count            = 2
    type                 = "VirtualMachineScaleSets"
  }

  network_profile {
    network_plugin     = var.network_plugin 
    dns_service_ip     = var.dns_service_ip
    service_cidr       = var.service_cidr
    pod_cidr           = var.pod_cidr
  }
  private_cluster_enabled = true
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet-link" {
  name = "dnslink-vnet02"
  private_dns_zone_name = join(".", slice(split(".", azurerm_kubernetes_cluster.cluster.private_fqdn), 1, length(split(".", azurerm_kubernetes_cluster.cluster.private_fqdn))))
  resource_group_name   = "MC_${azurerm_resource_group.rg.name}_${azurerm_kubernetes_cluster.cluster.name}_${azurerm_resource_group.rg.location}"
  virtual_network_id    = azurerm_virtual_network.vnet-2.id
}
