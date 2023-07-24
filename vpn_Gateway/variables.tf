variable "rgname" {
  default = "Abhishek-rg"
}

variable "location" {
  default = "westus"
}

variable "sharedKey" {
  description = "Shared key for vnet to vnet connection"
}

variable "type" {
  default = "Vpn"
}

variable "vpn-type" {
  default = "RouteBased"
}

variable "gatewaySKU" {
  default = "VpnGw1"
}