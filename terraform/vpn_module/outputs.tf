output "elastic_ips" {
  value = ["${aws_eip.vpn_endpoint.*.public_ip}"]
}
