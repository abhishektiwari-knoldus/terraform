output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.k8s.name
}

output "key_data" {
  value     = azapi_resource.ssh_public_key.body
  sensitive = true
}

