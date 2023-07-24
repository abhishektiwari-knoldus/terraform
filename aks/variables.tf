variable "pass" {
  type = string
  default = "Abhishek@12345"
}

variable "sourceh" {
  type = string
  default = "/home/knoldus/deploy.yml"
}

variable "destinaton" {
  type = string
  default = "./deployy.yml"
}

variable "computername" {
  type = string
  default = "myvm"
}

variable "adminusername" {
  type = string
  default = "akash001"
}

variable "rgname" {
  type = string
  default = "Abhishek-Main-RG"
}

variable "loc" {
  type = string
  default = "eastasia"
}

variable "clustername" {
  type = string
  default = "abhishek-private-cluster"
}

variable "dnsprefix" {
  type = string
  default = "myakscluster"
}

variable "identity" {
  type = string
  default = "SystemAssigned"
}

variable "network_plugin" {
  type = string
  default = "kubenet"
}

variable "dns_service_ip" {
  default = "192.100.1.1"
}

variable "service_cidr" {
  default = "192.100.0.0/16"
}

variable "pod_cidr" {

  default = "172.16.0.0/22"
}



