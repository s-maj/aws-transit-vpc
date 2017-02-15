resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.satellite.id}"
  propagating_vgws = [
    "${aws_vpn_gateway.vgw.id}",
  ]

  tags {
    Name = "${var.name}-public"
  }
}

resource "aws_route" "default_route" {
  route_table_id = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.default.id}"
  depends_on = [ "aws_route_table.public" ]
}

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.satellite.id}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
  cidr_block = "${element(var.public_cidr_list, count.index)}"
  map_public_ip_on_launch = true
  count = "${length(var.public_cidr_list)}"

  tags {
    Name = "${var.name}-public-${element(data.aws_availability_zones.available.names, count.index)}"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
  count = "${length(var.public_cidr_list)}"
}
