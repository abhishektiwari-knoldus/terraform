variable "resource_group_location" {
  type        = string
  default     = "westus"
  description = "Location of the resource group."
}



variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 2
}

variable "msi_id" {
  type        = string
  description = "The Managed Service Identity ID. Set this value if you're running this example using Managed Identity as the authentication method."
  default     = null
}
variable "rgname" {
  default = "Abhishek-rg1"
}
variable "k8sname" {
  type = string
}

variable "dns" {
  type = string
}

variable "pool" {
  type = string
}

variable "vmsize" {
  type = string
}

variable "adminuser" {
  type = string
}

variable "netpugin" {
  type = string
}

variable "lbsku" {
  type = string
}

variable "identitytype" {
  type = string
}


