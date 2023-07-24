
data "azurerm_resource_group" "rg" {
  name = "Abhishek-rg"
}

resource "azurerm_virtual_network" "vm-vnet" {
  name = "vnet_terraform"
  resource_group_name = data.azurerm_resource_group.rg.name
  location = var.loc
  address_space = ["10.3.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name = "tf-subnet"
  resource_group_name = data.azurerm_resource_group.rg.name
  address_prefixes = ["10.3.0.0/24"]
  virtual_network_name = azurerm_virtual_network.vm-vnet.name
}

resource "azurerm_public_ip" "myPubIP" {
  name                = "myPublicIP"
  location            = var.loc
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "my_nsg" {
  name                = "tf-nsg"
  location            = var.loc
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "mynic" {
  name                = "myNIC"
  location            = var.loc
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "nic_configuration"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myPubIP.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.mynic.id
  network_security_group_id = azurerm_network_security_group.my_nsg.id
}

# # Create (and display) an SSH key
# resource "tls_private_key" "example_ssh" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }


data "azurerm_key_vault" "vault" {                        //**********************
  depends_on = [ azurerm_key_vault.vault ]
  name                        = azurerm_key_vault.vault.name
  resource_group_name         =  data.azurerm_resource_group.rg.name
}



resource "azurerm_linux_virtual_machine" "my_terraform_vm" {

  depends_on = [ azurerm_key_vault.vault ]

  name                  = "mytfVM"
  location              = var.loc
  resource_group_name   = data.azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.mynic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
 source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "myvm"
  admin_username                  = "akash"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "akash"
    public_key = azurerm_key_vault_secret.ssh-key.value                   #public_key = tls_private_key.example_ssh.public_key_openssh
  }
}


