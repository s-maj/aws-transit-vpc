
variable "vpc_id" {
  type    = "string"
}

variable "instance_type" {
  type = "string"
}

variable "root_size" {
  default = "40"
  type = "string"
}

variable "subnet_list_id" {
  type = "list"
}

variable "key_name" {
  type = "string"
}

variable "instance_count" {
  type = "string"
}

variable "tags" {
  type = "map"
}

variable "asn_list" {
  type = "list"
}

variable "region" {
  type    = "string"
  default = "eu-west-1"
}