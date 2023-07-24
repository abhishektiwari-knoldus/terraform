output "tls_private_key" {
  value     = tls_private_key.example_ssh1.private_key_pem
  sensitive = true
}

output "private_ip" {
  value = azurerm_network_interface.mynic2.private_ip_address

}


