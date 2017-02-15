resource "aws_instance" "ec2" {
  ami                    = "${data.aws_ami.centos_ami.image_id}"
  instance_type          = "${var.instance_type}"
  monitoring             = true
  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.ec2.id}"]
  key_name               = "${var.key_name}"
  tags                   = "${var.tags}"
  lifecycle {
    ignore_changes       = ["user_data"]
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = "${var.root_size}"
    volume_type           = "gp2"
  }
}

