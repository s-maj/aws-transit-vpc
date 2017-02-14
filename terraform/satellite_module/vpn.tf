resource "aws_customer_gateway" "cgw_a" {
    bgp_asn    = "${var.cgw_a_asn}"
    ip_address = "${var.cgw_a_ip}"
    type       = "ipsec.1"

    tags {
        Name = "${var.name}"
    }
}

resource "aws_customer_gateway" "cgw_b" {
    bgp_asn    = "${var.cgw_b_asn}"
    ip_address = "${var.cgw_b_ip}"
    type        = "ipsec.1"

    tags {
        Name = "${var.name}"
    }
}

resource "aws_vpn_gateway" "vgw" {
    vpc_id            = "${aws_vpc.satellite.id}"

    tags {
        Name = "${var.name}"
    }
}

resource "aws_vpn_connection" "vpn_a" {
    vpn_gateway_id      = "${aws_vpn_gateway.vgw.id}"
    customer_gateway_id = "${aws_customer_gateway.cgw_a.id}"
    type                = "ipsec.1"
    static_routes_only  = false

    tags {
        Name = "${var.name}"
        BIRD = "True"
        ID = "${var.cgw_a_ip}"
    }
}

resource "aws_vpn_connection" "vpn_b" {
    vpn_gateway_id      = "${aws_vpn_gateway.vgw.id}"
    customer_gateway_id = "${aws_customer_gateway.cgw_b.id}"
    type                = "ipsec.1"
    static_routes_only  = false

    tags {
        Name = "${var.name}"
        BIRD = "True"
        ID = "${var.cgw_b_ip}"
    }
}
