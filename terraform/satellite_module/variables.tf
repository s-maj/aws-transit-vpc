variable "name" {
  type = "string"
}

variable "cidr_block" {
  type = "string"
}

variable "public_a_cidr" {
  type = "string"
}

variable "public_b_cidr" {
  type = "string"
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

variable "iterator" {
  type = "list"
  default = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10]
}