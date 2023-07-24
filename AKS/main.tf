

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = var.rgname
}



resource "azurerm_kubernetes_cluster" "k8s" {
  location            = azurerm_resource_group.rg.location
  name                = var.k8sname
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dns

  identity {
    type =  var.identitytype                              
  }

  default_node_pool {
    name       =  var.pool                             
    vm_size    =  var.vmsize                 
    node_count = var.node_count
  }
  linux_profile {
    admin_username =  var.adminuser                  

    ssh_key {
      key_data = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
    }
  }
  network_profile {
    network_plugin    =  var.netpugin                          
    load_balancer_sku =  var.lbsku                        
  }
}




