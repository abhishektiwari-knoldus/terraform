output "resource_group_name" {
  value = data.azurerm_resource_group.rg.name
}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address
}

# output "tls_private_key" {
#   value     = tls_private_key.example_ssh.private_key_pem
#   sensitive = true
# }

output "secret_value" {
  value     = azurerm_key_vault_secret.ssh-key.value
  sensitive = true
}


output "random_string" {
  value = random_string.random.result
}