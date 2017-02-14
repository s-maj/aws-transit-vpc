variable "name" {
  type    = "string"
}

variable "cidr_block" {
  type    = "string"
}

variable "public_a_cidr" {
  type    = "string"
}

variable "public_b_cidr" {
  type    = "string"
}

variable "cgw_a_asn" {
  type    = "string"
}

variable "cgw_b_asn" {
  type    = "string"
}

variable "cgw_a_ip" {
  type    = "string"
}

variable "cgw_b_ip" {
  type    = "string"
}

variable "profile_name" {
  type    = "string"
  default = "default"
}

variable "role_arn" {
  type    = "string"
  default = ""
}

variable "region" {
  type    = "string"
  default = "eu-west-1"
}
