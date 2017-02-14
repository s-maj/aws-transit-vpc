resource "aws_iam_role" "ec2_role" {
  name               = "${var.tags["Name"]}-role"
  assume_role_policy = "${data.template_file.role_profile.rendered}"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  roles = ["${aws_iam_role.ec2_role.id}"]
}

resource "aws_iam_role_policy" "ec2_role_policy" {
  name   = "${var.tags["Name"]}-policy"
  role   = "${aws_iam_role.ec2_role.id}"
  policy = "${data.template_file.role_policy.rendered}"
}
