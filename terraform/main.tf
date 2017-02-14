module "satellite-nvirginia" {
  source = "./satellite_module"

  name          = "satellite-nvirginia"
  cidr_block    = "192.168.220.0/24"
  public_a_cidr = "192.168.220.0/25"
  public_b_cidr = "192.168.220.128/25"
  cgw_a_asn     = "65000"
  cgw_b_asn     = "65001"
  cgw_a_ip      = "${module.vpn-server.elastic_ips[0]}"
  cgw_b_ip      = "${module.vpn-server.elastic_ips[1]}"
  profile_name  = "dnb-dublin"
  role_arn      = "arn:aws:iam::800040397897:role/Administrator"
  region        = "us-east-1"
}

module "satellite-oregon" {
  source = "./satellite_module"

  name          = "satellite-nvirginia"
  cidr_block    = "192.168.221.0/24"
  public_a_cidr = "192.168.221.0/25"
  public_b_cidr = "192.168.221.128/25"
  cgw_a_asn     = "65000"
  cgw_b_asn     = "65001"
  cgw_a_ip      = "${module.vpn-server.elastic_ips[0]}"
  cgw_b_ip      = "${module.vpn-server.elastic_ips[1]}"
  profile_name  = "dnb-dublin"
  role_arn      = "arn:aws:iam::800040397897:role/Administrator"
  region        = "us-west-2"
}

module "vpn-server" {
  source = "./vpn_module"

  vpc_id         = "vpc-58afc23c"
  subnet_list_id = ["subnet-50820108", "subnet-40017e36"]
  instance_type  = "t2.small"
  key_name       = "AWSlab"
  instance_count = 2
  profile_name   = "dnb-dublin"
  role_arn       = "arn:aws:iam::800040397897:role/Administrator"
  region         = "eu-west-1"

  tags =  {
    Name       = "strongSwan",
    BIRD       = "True",
    strongSwan = "True"
  }
}
