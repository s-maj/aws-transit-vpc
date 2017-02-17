module "satellite-nvirginia" {
  source = "./satellite_module"

  name             = "satellite-nvirginia"
  cidr_block       = "192.168.220.0/24"
  public_cidr_list = [ "192.168.220.0/25", "192.168.220.128/25" ]
  asn_list         = [ "65200", "65201" ]
  cgw_ip_list      = "${module.vpn-server.elastic_ips}"
  region           = "us-east-1"
}

module "satellite-oregon" {
  source = "./satellite_module"

  name             = "satellite-nvirginia"
  cidr_block       = "192.168.221.0/24"
  public_cidr_list = [ "192.168.221.0/25", "192.168.221.128/25" ]
  asn_list         = [ "65200", "65201" ]
  cgw_ip_list      = "${module.vpn-server.elastic_ips}"
  region           = "us-west-2"
}

module "vpn-probe-satellite-nvirginia" {
  source = "./probe_module"

  vpc_id        = "${module.satellite-nvirginia.vpc_id}"
  subnet_id     = "${module.satellite-nvirginia.subnet_id[0]}"
  instance_type = "t2.nano"
  key_name      = "AWSlab"
  region        = "us-east-1"

  tags =  {
    Name       = "satellite-nvirginia-probe",
  }
}

module "vpn-probe-satellite-oregon" {
  source = "./probe_module"

  vpc_id        = "${module.satellite-oregon.vpc_id}"
  subnet_id     = "${module.satellite-oregon.subnet_id[0]}"
  instance_type = "t2.nano"
  key_name      = "AWSlab"
  region        = "us-west-2"

  tags =  {
    Name       = "satellite-nvirginia-probe",
  }
}

module "vpn_direct_connect" {
  source = "./direct_connect_module"

  name               = "strongSwanToDirectConnect"
  direct_connect_vgw = "vgw-26c3f052"
  asn_list           = [ "65200", "65201" ]
  cgw_ip_list        = "${module.vpn-server.elastic_ips}"
  region             = "eu-west-1"
}

module "vpn-server" {
  source = "./vpn_module"

  vpc_id         = "vpc-58afc23c"
  subnet_list_id = ["subnet-50820108", "subnet-40017e36"]
  instance_type  = "t2.small"
  key_name       = "AWSlab"
  instance_count = 2
  asn_list       = [ "65200", "65201" ]
  region         = "eu-west-1"

  tags =  {
    Name       = "strongSwan",
    bird       = "True",
    strongSwan = "True"
  }
}
