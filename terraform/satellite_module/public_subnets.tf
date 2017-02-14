resource "aws_route_table" "public" {
  vpc_id           = "${aws_vpc.satellite.id}"
  propagating_vgws = [
    "${aws_vpn_gateway.vgw.id}",
  ]

  tags {
      Name = "${var.name}-public"
  }
}

resource "aws_route" "default_route" {
    route_table_id         = "${aws_route_table.public.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = "${aws_internet_gateway.default.id}"
    depends_on             = ["aws_route_table.public"]
}

resource "aws_subnet" "public_a" {
    vpc_id                  = "${aws_vpc.satellite.id}"
    availability_zone       = "${data.aws_availability_zones.available.names[0]}"
    map_public_ip_on_launch = true
    cidr_block              = "${var.public_a_cidr}"

    tags {
        Name = "${var.name}-public-${data.aws_availability_zones.available.names[0]}"
    }
}

resource "aws_subnet" "public_b" {
    vpc_id                  = "${aws_vpc.satellite.id}"
    availability_zone       = "${data.aws_availability_zones.available.names[1]}"
    map_public_ip_on_launch = true
    cidr_block              = "${var.public_b_cidr}"

    tags {
        Name = "${var.name}-public-${data.aws_availability_zones.available.names[1]}"
    }
}

resource "aws_route_table_association" "public_a" {
    subnet_id      = "${aws_subnet.public_a.id}"
    route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "public_b" {
    subnet_id      = "${aws_subnet.public_b.id}"
    route_table_id = "${aws_route_table.public.id}"
}
