resource "aws_instance" "ec2" {
  ami                    = "${data.aws_ami.centos_ami.image_id}"
  instance_type          = "${var.instance_type}"
  monitoring             = true
  subnet_id              = "${element(var.subnet_list_id, count.index)}"
  vpc_security_group_ids = ["${aws_security_group.ec2.id}"]
  iam_instance_profile   = "${aws_iam_instance_profile.ec2_profile.id}"
  key_name               = "${var.key_name}"
  user_data              = "${data.template_file.userdata.rendered}"
  tags                   = "${merge(var.tags, map("asn", element(var.asn_list, count.index)))}"
  count                  = "${var.instance_count}"
  lifecycle {
    ignore_changes       = ["user_data"]
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = "${var.root_size}"
    volume_type           = "gp2"
  }
}

resource "aws_eip" "vpn_endpoint" {
  vpc      = true
  instance = "${element(aws_instance.ec2.*.id, count.index)}"
  count    = "${var.instance_count}"
}

resource "aws_cloudwatch_metric_alarm" "auto-recover" {
  alarm_name          = "${var.tags["Name"]}-${count.index}-autorecover"
  namespace           = "AWS/EC2"
  evaluation_periods  = "5"
  period              = "60"
  alarm_description   = "This metric auto recovers EC2 instances"
  alarm_actions       = ["arn:aws:automate:${data.aws_region.current.name}:ec2:recover"]
  statistic           = "Minimum"
  comparison_operator = "GreaterThanThreshold"
  threshold           = "1"
  metric_name         = "StatusCheckFailed_System"
  count               = "${var.instance_count}"
  dimensions {
      InstanceId      = "${element(aws_instance.ec2.*.id, count.index)}"
  }
}
