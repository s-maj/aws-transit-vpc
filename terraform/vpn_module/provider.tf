provider "aws" {
  profile = "${var.profile_name}"
  region  = "${var.region}"
  assume_role {
    role_arn = "${var.role_arn}"
  }
}
