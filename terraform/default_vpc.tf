data "aws_region" "current" {}

resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = "${data.aws_region.current.name}a"
}

resource "aws_default_subnet" "default_subnet_b" {
  availability_zone = "${data.aws_region.current.name}b"
}
