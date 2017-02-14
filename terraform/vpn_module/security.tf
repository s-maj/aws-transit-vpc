resource "aws_security_group" "ec2" {
  name = "${var.tags["Name"]}"
  vpc_id = "${var.vpc_id}"
}

resource "aws_security_group_rule" "egress" {
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "all"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ec2.id}"
}

resource "aws_security_group_rule" "ipsec_1" {
  type = "ingress"
  from_port = 500
  to_port = 500
  protocol = "udp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ec2.id}"
}

resource "aws_security_group_rule" "ipsec_2" {
  type = "ingress"
  from_port = 4500
  to_port = 4500
  protocol = "udp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ec2.id}"
}

resource "aws_security_group_rule" "ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["10.0.0.0/8"]
  security_group_id = "${aws_security_group.ec2.id}"
}

resource "aws_security_group_rule" "bgp_inter_sg" {
  type = "ingress"
  from_port = 179
  to_port = 179
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.ec2.id}"
  security_group_id = "${aws_security_group.ec2.id}"
}
