variable "name" {
  type = "string"
}

variable "cidr_block" {
  type = "string"
}

variable "public_cidr_list" {
  type = "list"
}

variable "cgw_asn_list" {
  type = "list"
}

variable "cgw_ip_list" {
  type = "list"
}

variable "region" {
  type = "string"
  default = "eu-west-1"
}