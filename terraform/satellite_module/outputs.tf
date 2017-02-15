output "vpc_id" {
  value = "${(aws_vpc.satellite.id)}"
}

output "subnet_id" {
  value = ["${aws_subnet.public.*.id}"]
}