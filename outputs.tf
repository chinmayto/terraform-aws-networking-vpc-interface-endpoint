output "vpc_a_bastion_host_IP" {
  value = module.vpc_a_bastion_host.public_ip
}

output "vpc_interface_endpoint_dns_entry" {
  value = aws_vpc_endpoint.sqs_vpc_ep_interface.*.dns_entry
}

output "sqs_url" {
  value = aws_sqs_queue.sqs.url
}