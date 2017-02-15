variable "name" {
  type = "string"
}

variable "cgw_asn_list" {
  type = "list"
}

variable "cgw_ip_list" {
  type = "list"
}

variable "direct_connect_vgw" {
  type = "string"
}

variable "region" {
  type = "string"
  default = "eu-west-1"
}