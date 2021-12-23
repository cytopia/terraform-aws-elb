output "security_group_ids" {
  description = "The IDs of the ELB security groups to attach the the LC/ASG/EC2 instance in order to be accessable by the ELB."
  value       = [element(concat(aws_security_group.elb.*.id, [""]), 0)]
}

output "id" {
  description = "The name of the ELB"
  value       = element(concat(aws_elb.elb.*.id, [""]), 0)
}

output "name" {
  description = "The name of the ELB"
  value       = element(concat(aws_elb.elb.*.name, [""]), 0)
}

output "fqdn" {
  description = "The auto-generated FQDN of the ELB."
  value       = element(concat(aws_elb.elb.*.dns_name, [""]), 0)
}

output "route53_public_dns_name" {
  description = "The route53 public dns name of the ELB if set."
  value       = var.route53_public_dns_name
}

output "route53_private_dns_name" {
  description = "The route53 private dns name of the ELB if set."
  value       = var.route53_private_dns_name
}
