variable "location" {
  type        = string
  default     = "eastus"
}

variable "rgname" {
  type        = string
  default     = "Abhishek-rg"
}

variable "container_group_name" {
  type        = string
  default     = "acigroup"
}

variable "container_name" {
  type        = string
  default     = "aci"
}

variable "image" {
  type        = string
  default     = "mcr.microsoft.com/azuredocs/aci-helloworld"
}

variable "port" {
  type        = number
  default     = 80
}

variable "cpu" {
  type        = number
  description = "The number of CPU cores to allocate to the container."
  default     = 1
}

variable "memory" {
  type        = number
  default     = 2
}

variable "restart_policy" {
  type        = string
  default     = "Always"
}

variable "iptype" {
  default = "Private"
}

variable "ostype" {
  default = "Windows"
}

variable "prot" {
default = "TCP"
}