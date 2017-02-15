resource "aws_customer_gateway" "cgw" {
  bgp_asn = "${element(var.cgw_asn_list, count.index)}"
  ip_address = "${element(var.cgw_ip_list, count.index)}"
  type = "ipsec.1"
  count = "${length(var.cgw_asn_list)}"

  tags {
    Name = "${var.name}"
  }
}

resource "aws_vpn_gateway" "vgw" {
  vpc_id = "${aws_vpc.satellite.id}"

  tags {
    Name = "${var.name}"
  }
}

resource "aws_vpn_connection" "vpn" {
  vpn_gateway_id = "${aws_vpn_gateway.vgw.id}"
  customer_gateway_id = "${element(aws_customer_gateway.cgw.*.id, count.index)}"
  type = "ipsec.1"
  static_routes_only = false
  count = "${length(var.cgw_asn_list)}"

  tags {
    Name = "${var.name}"
    BIRD = "True"
    ID = "${element(var.cgw_asn_list, count.index)}"
  }
}

