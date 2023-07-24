locals {
  first_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+wWK73dCr+jgQOAxNsHAnNNNMEMWOHYEccp6wJm2gotpr9katuF/ZAdou5AaW1C61slRkHRkpRRX9FA9CYBiitZgvCCz+3nWNN7l/Up54Zps/pHWGZLHNJZRYyAB6j5yVLMVHIHriY49d/GZTZVNB8GoJv9Gakwc/fuEZYYl4YDFiGMBP///TzlI4jhiJzjKnEvqPFki5p2ZRJqcbCiF4pJrxUQR/RXqVFQdbRLZgYfJ8xGB878RENq3yQ39d8dVOkq4edbkzwcUmwwwkYVPIoDGsYLaRHnG+To7FvMeyO7xDVQkMKzopTQV8AuKpyvpqu0a9pWOMaiCyDytO7GGN you@me.com"
}

variable "rgname" {
    default = "Abhishek-rg1"
  
}


data "azurerm_resource_group" "rg" {
  name = var.rgname

}

data "template_file" "nginx-cloud-init" {
  template = file("install-nginx.sh")
}


resource "azurerm_linux_virtual_machine_scale_set" "rg" {
  name                = "rg-vmss"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = "Standard_F2"
  instances           = 1
  admin_username      = "akash"

  admin_ssh_key {
    username   = "akash"
    public_key = local.first_public_key
  }

  custom_data = base64encode(data.template_file.nginx-cloud-init.rendered)

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "nic-lb"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = azurerm_subnet.LB-Subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.MyBackendPool.id]
    }
  }

}

resource "azurerm_monitor_autoscale_setting" "example" {
  name                = "my-autoscale-setting"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.rg.id

  profile {
    name = "default"
    capacity {
      default = 1
      minimum = 1
      maximum = 3
    }
    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.rg.id
        operator           = "GreaterThan"
        statistic          = "Average"
        threshold          = 30
        time_aggregation   = "Average"
        time_grain         = "PT1M"
        time_window        = "PT1M"
      }
      scale_action {
        cooldown  = "PT1M"
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
      }
    }
    rule {
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = 1
        cooldown  = "PT5M"
      }
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.rg.id
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT1M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 10
      }
    }
  }
}







