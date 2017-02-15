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

resource "aws_security_group_rule" "ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ec2.id}"
}

resource "aws_security_group_rule" "icmp" {
  type = "ingress"
  from_port = -1
  to_port = -1
  protocol = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ec2.id}"
}