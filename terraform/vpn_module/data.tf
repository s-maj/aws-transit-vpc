data "aws_ami" "centos_ami" {
  most_recent = true
  filter {
    name = "product-code"
    values = ["aw0evgkw8e5c1q413zgy5pjce"]
  }
}

data "aws_region" "current" {
  current = true
}


data "template_file" "role_profile" {
  template = "${file("${path.module}/templates/profile.json")}"
}

data "template_file" "role_policy" {
  template = "${file("${path.module}/templates/policy.json")}"
}

data "template_file" "userdata" {
    template = "${file("${path.module}/templates/userdata.sh")}"
}