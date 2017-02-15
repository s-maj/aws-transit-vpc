
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

variable "subnet_id" {
  type = "string"
}

variable "key_name" {
  type = "string"
}

variable "tags" {
  type = "map"
}

variable "region" {
  type    = "string"
  default = "eu-west-1"
}
