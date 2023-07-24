#vm1

resource "azurerm_network_security_group" "my_nsg1" {
  name                = "tf-nsg1"
  location            = var.location
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

resource "azurerm_network_interface" "mynic1" {
  name                = "myNIC1"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "nic_configuration1"
    subnet_id                     = azurerm_subnet.subnetgvm.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nsgNic1" {
  network_interface_id      = azurerm_network_interface.mynic1.id
  network_security_group_id = azurerm_network_security_group.my_nsg1.id
}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "my_terraform_vm1" {
  name                  = "mytfVM1"
  location              = var.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.mynic1.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk1"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "myvm1"
  admin_username                  = "akash"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "akash"
    public_key = tls_private_key.example_ssh1.public_key_openssh
  }
}

#vm2

resource "azurerm_network_security_group" "my_nsg2" {
  name                = "tf-nsg2"
  location            = var.location
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

resource "azurerm_network_interface" "mynic2" {
  name                = "myNIC2"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "nic_configuration2"
    subnet_id                     = azurerm_subnet.subnetgvm1.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nsgNic2" {
  network_interface_id      = azurerm_network_interface.mynic2.id
  network_security_group_id = azurerm_network_security_group.my_nsg2.id
}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh2" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine" "my_terraform_vm2" {
  name                  = "mytfVM2"
  location              = var.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.mynic2.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk2"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "myvm2"
  admin_username                  = "akash"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "akash"
    public_key = tls_private_key.example_ssh2.public_key_openssh
  }
}