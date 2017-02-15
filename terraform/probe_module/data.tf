data "aws_ami" "centos_ami" {
  most_recent = true
  filter {
    name = "product-code"
    values = ["aw0evgkw8e5c1q413zgy5pjce"]
  }
}

data "aws_region" "current" {
  current = true
}