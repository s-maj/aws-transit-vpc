module "satellite-nvirginia" {
  source = "./satellite_module"

  name          = "satellite-nvirginia"
  cidr_block    = "192.168.220.0/24"
  public_a_cidr = "192.168.220.0/25"
  public_b_cidr = "192.168.220.128/25"
  cgw_asn_list   = [ "65000", "65001" ]
  cgw_ip_list   = "${module.vpn-server.elastic_ips}"
  region        = "us-east-1"
}

module "satellite-oregon" {
  source = "./satellite_module"

  name          = "satellite-nvirginia"
  cidr_block    = "192.168.221.0/24"
  public_a_cidr = "192.168.221.0/25"
  public_b_cidr = "192.168.221.128/25"
  cgw_asn_list  = [ "65000", "65001" ]
  cgw_ip_list   = "${module.vpn-server.elastic_ips}"
  region        = "us-west-2"
}

module "vpn-server" {
  source = "./vpn_module"

  vpc_id         = "vpc-58afc23c"
  subnet_list_id = ["subnet-50820108", "subnet-40017e36"]
  instance_type  = "t2.small"
  key_name       = "AWSlab"
  instance_count = 2
  region         = "eu-west-1"

  tags =  {
    Name       = "strongSwan",
    BIRD       = "True",
    strongSwan = "True"
  }
}
