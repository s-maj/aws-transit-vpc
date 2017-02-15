resource "aws_vpc" "satellite" {
  cidr_block = "${var.cidr_block}"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name = "${var.name}"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.satellite.id}"

  tags {
    Name = "${var.name}"
  }
}
