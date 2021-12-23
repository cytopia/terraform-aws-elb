# Terraform module: AWS ELB

[![Build Status](https://travis-ci.org/Flaconi/terraform-aws-elb.svg?branch=master)](https://travis-ci.org/Flaconi/terraform-aws-elb)
[![Tag](https://img.shields.io/github/tag/Flaconi/terraform-aws-elb.svg)](https://github.com/Flaconi/terraform-aws-elb/releases)
[![Terraform](https://img.shields.io/badge/Terraform--registry-aws--elb-brightgreen.svg)](https://registry.terraform.io/modules/Flaconi/elb/aws/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

This Terraform module creates an ELB with optionally a public and/or private Route53 DNS record attached to it.
Additionally it provides the option to attach the created ELB to an autoscaling group by name.

## Usage

```hcl
module "elb" {
  source  = "github.com/Flaconi/terraform-aws-elb?ref=v1.1.0"

  name       = "my-elb"
  vpc_id     = "vpc-12345"
  subnet_ids = ["subnet-1234", "subnet-5677"]

  # Attach the ELB to an ASG by this name
  asg_name = "my-service"

  # Listener
  lb_port       = 443
  instance_port = 80

  # Security
  inbound_cidr_blocks = ["0.0.0.0/0"]

  # Create this route53 public DNS record
  route53_public_dns_name = "my-service.example.com"
}
```

## Examples

* [Complete ELB](examples/complete/)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.26 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_attachment.asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_elb.elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elb) | resource |
| [aws_route53_record.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_route53_zone.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_route53_zone.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_security_groups.elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_groups) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable"></a> [enable](#input\_enable) | Whether or not to enable this module. This is required due to the lack of using count for modules. Set it to false to disable the creation of the ELB. Defaults to true | `bool` | `true` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC to add this ELB to. | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet ids to place the ELB into. | `list(string)` | n/a | yes |
| <a name="input_asg_name"></a> [asg\_name](#input\_asg\_name) | Name of the auto scaling group to attach to. If this value is empty, no attachment will be done and is be left to the end-user via custom 'aws\_autoscaling\_group' or 'aws\_autoscaling\_attachment' definitions. | `string` | `""` | no |
| <a name="input_inbound_cidr_blocks"></a> [inbound\_cidr\_blocks](#input\_inbound\_cidr\_blocks) | List of CIDR's that are allowed to access the ELB. | `list(string)` | n/a | yes |
| <a name="input_security_group_names"></a> [security\_group\_names](#input\_security\_group\_names) | List of one or more security groups to be added to the load balancer | `list(string)` | `[]` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | If true, ELB will be an internal ELB. | `bool` | `false` | no |
| <a name="input_cross_zone_load_balancing"></a> [cross\_zone\_load\_balancing](#input\_cross\_zone\_load\_balancing) | Enable cross-zone load balancing. | `bool` | `true` | no |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | The time in seconds that the connection is allowed to be idle. | `number` | `60` | no |
| <a name="input_connection_draining"></a> [connection\_draining](#input\_connection\_draining) | Boolean to enable connection draining. | `bool` | `false` | no |
| <a name="input_connection_draining_timeout"></a> [connection\_draining\_timeout](#input\_connection\_draining\_timeout) | The time in seconds to allow for connections to drain | `number` | `300` | no |
| <a name="input_lb_port"></a> [lb\_port](#input\_lb\_port) | On what port do you want to access the ELB. | `number` | n/a | yes |
| <a name="input_instance_port"></a> [instance\_port](#input\_instance\_port) | On what port does the ELB access the instances. | `number` | n/a | yes |
| <a name="input_lb_protocol"></a> [lb\_protocol](#input\_lb\_protocol) | On what protocol should the load balancer respond. | `string` | `"TCP"` | no |
| <a name="input_instance_protocol"></a> [instance\_protocol](#input\_instance\_protocol) | On what protocol does the instance respond. | `string` | `"TCP"` | no |
| <a name="input_ssl_certificate_id"></a> [ssl\_certificate\_id](#input\_ssl\_certificate\_id) | "The ARN of an SSL certificate you have uploaded to AWS IAM or<br>ACM. Only valid when lb\_protocol is either HTTPS or SSL" | `string` | `""` | no |
| <a name="input_healthy_threshold"></a> [healthy\_threshold](#input\_healthy\_threshold) | The number of checks before the instance is declared healthy. | `number` | `10` | no |
| <a name="input_unhealthy_threshold"></a> [unhealthy\_threshold](#input\_unhealthy\_threshold) | The number of checks before the instance is declared unhealthy. | `number` | `2` | no |
| <a name="input_target"></a> [target](#input\_target) | The target of the check. If unset, will default to 'instance\_protocol:instance\_port' for TCP/SLL and 'instance\_protocol:instance\_port/' for HTTP/HTTPS. | `string` | `""` | no |
| <a name="input_interval"></a> [interval](#input\_interval) | The interval between checks. | `number` | `30` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The length of time before the check times out. | `number` | `5` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the ELB and security group resources. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources. | `map(string)` | `{}` | no |
| <a name="input_sg_name_suffix_elb"></a> [sg\_name\_suffix\_elb](#input\_sg\_name\_suffix\_elb) | Name suffix to append to the ELB security group. | `string` | `"-elb"` | no |
| <a name="input_route53_public_dns_name"></a> [route53\_public\_dns\_name](#input\_route53\_public\_dns\_name) | If set, the ELB will be assigned this public DNS name via Route53. | `string` | `""` | no |
| <a name="input_route53_private_dns_name"></a> [route53\_private\_dns\_name](#input\_route53\_private\_dns\_name) | If set, the ELB will be assigned this private DNS name via Route53. | `string` | `""` | no |
| <a name="input_public_dns_evaluate_target_health"></a> [public\_dns\_evaluate\_target\_health](#input\_public\_dns\_evaluate\_target\_health) | Set to true if you want Route 53 to determine whether to respond to DNS queries using this resource record set by checking the health of the resource record set. | `bool` | `true` | no |
| <a name="input_private_dns_evaluate_target_health"></a> [private\_dns\_evaluate\_target\_health](#input\_private\_dns\_evaluate\_target\_health) | Set to true if you want Route 53 to determine whether to respond to DNS queries using this resource record set by checking the health of the resource record set. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_security_group_ids"></a> [security\_group\_ids](#output\_security\_group\_ids) | The IDs of the ELB security groups to attach the the LC/ASG/EC2 instance in order to be accessable by the ELB. |
| <a name="output_id"></a> [id](#output\_id) | The name of the ELB |
| <a name="output_name"></a> [name](#output\_name) | The name of the ELB |
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | The auto-generated FQDN of the ELB. |
| <a name="output_route53_public_dns_name"></a> [route53\_public\_dns\_name](#output\_route53\_public\_dns\_name) | The route53 public dns name of the ELB if set. |
| <a name="output_route53_private_dns_name"></a> [route53\_private\_dns\_name](#output\_route53\_private\_dns\_name) | The route53 private dns name of the ELB if set. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


<!-- TFDOCS_INPUTS_START -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.26 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_attachment.asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_elb.elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elb) | resource |
| [aws_route53_record.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_route53_zone.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_route53_zone.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_security_groups.elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_groups) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable"></a> [enable](#input\_enable) | Whether or not to enable this module. This is required due to the lack of using count for modules. Set it to false to disable the creation of the ELB. Defaults to true | `bool` | `true` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC to add this ELB to. | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet ids to place the ELB into. | `list(string)` | n/a | yes |
| <a name="input_asg_name"></a> [asg\_name](#input\_asg\_name) | Name of the auto scaling group to attach to. If this value is empty, no attachment will be done and is be left to the end-user via custom 'aws\_autoscaling\_group' or 'aws\_autoscaling\_attachment' definitions. | `string` | `""` | no |
| <a name="input_inbound_cidr_blocks"></a> [inbound\_cidr\_blocks](#input\_inbound\_cidr\_blocks) | List of CIDR's that are allowed to access the ELB. | `list(string)` | n/a | yes |
| <a name="input_security_group_names"></a> [security\_group\_names](#input\_security\_group\_names) | List of one or more security groups to be added to the load balancer | `list(string)` | `[]` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | If true, ELB will be an internal ELB. | `bool` | `false` | no |
| <a name="input_cross_zone_load_balancing"></a> [cross\_zone\_load\_balancing](#input\_cross\_zone\_load\_balancing) | Enable cross-zone load balancing. | `bool` | `true` | no |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | The time in seconds that the connection is allowed to be idle. | `number` | `60` | no |
| <a name="input_connection_draining"></a> [connection\_draining](#input\_connection\_draining) | Boolean to enable connection draining. | `bool` | `false` | no |
| <a name="input_connection_draining_timeout"></a> [connection\_draining\_timeout](#input\_connection\_draining\_timeout) | The time in seconds to allow for connections to drain | `number` | `300` | no |
| <a name="input_lb_port"></a> [lb\_port](#input\_lb\_port) | On what port do you want to access the ELB. | `number` | n/a | yes |
| <a name="input_instance_port"></a> [instance\_port](#input\_instance\_port) | On what port does the ELB access the instances. | `number` | n/a | yes |
| <a name="input_lb_protocol"></a> [lb\_protocol](#input\_lb\_protocol) | On what protocol should the load balancer respond. | `string` | `"TCP"` | no |
| <a name="input_instance_protocol"></a> [instance\_protocol](#input\_instance\_protocol) | On what protocol does the instance respond. | `string` | `"TCP"` | no |
| <a name="input_ssl_certificate_id"></a> [ssl\_certificate\_id](#input\_ssl\_certificate\_id) | "The ARN of an SSL certificate you have uploaded to AWS IAM or<br>ACM. Only valid when lb\_protocol is either HTTPS or SSL" | `string` | `""` | no |
| <a name="input_healthy_threshold"></a> [healthy\_threshold](#input\_healthy\_threshold) | The number of checks before the instance is declared healthy. | `number` | `10` | no |
| <a name="input_unhealthy_threshold"></a> [unhealthy\_threshold](#input\_unhealthy\_threshold) | The number of checks before the instance is declared unhealthy. | `number` | `2` | no |
| <a name="input_target"></a> [target](#input\_target) | The target of the check. If unset, will default to 'instance\_protocol:instance\_port' for TCP/SLL and 'instance\_protocol:instance\_port/' for HTTP/HTTPS. | `string` | `""` | no |
| <a name="input_interval"></a> [interval](#input\_interval) | The interval between checks. | `number` | `30` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The length of time before the check times out. | `number` | `5` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the ELB and security group resources. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources. | `map(string)` | `{}` | no |
| <a name="input_sg_name_suffix_elb"></a> [sg\_name\_suffix\_elb](#input\_sg\_name\_suffix\_elb) | Name suffix to append to the ELB security group. | `string` | `"-elb"` | no |
| <a name="input_route53_public_dns_name"></a> [route53\_public\_dns\_name](#input\_route53\_public\_dns\_name) | If set, the ELB will be assigned this public DNS name via Route53. | `string` | `""` | no |
| <a name="input_route53_private_dns_name"></a> [route53\_private\_dns\_name](#input\_route53\_private\_dns\_name) | If set, the ELB will be assigned this private DNS name via Route53. | `string` | `""` | no |
| <a name="input_public_dns_evaluate_target_health"></a> [public\_dns\_evaluate\_target\_health](#input\_public\_dns\_evaluate\_target\_health) | Set to true if you want Route 53 to determine whether to respond to DNS queries using this resource record set by checking the health of the resource record set. | `bool` | `true` | no |
| <a name="input_private_dns_evaluate_target_health"></a> [private\_dns\_evaluate\_target\_health](#input\_private\_dns\_evaluate\_target\_health) | Set to true if you want Route 53 to determine whether to respond to DNS queries using this resource record set by checking the health of the resource record set. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_security_group_ids"></a> [security\_group\_ids](#output\_security\_group\_ids) | The IDs of the ELB security groups to attach the the LC/ASG/EC2 instance in order to be accessable by the ELB. |
| <a name="output_id"></a> [id](#output\_id) | The name of the ELB |
| <a name="output_name"></a> [name](#output\_name) | The name of the ELB |
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | The auto-generated FQDN of the ELB. |
| <a name="output_route53_public_dns_name"></a> [route53\_public\_dns\_name](#output\_route53\_public\_dns\_name) | The route53 public dns name of the ELB if set. |
| <a name="output_route53_private_dns_name"></a> [route53\_private\_dns\_name](#output\_route53\_private\_dns\_name) | The route53 private dns name of the ELB if set. |

<!-- TFDOCS_INPUTS_END -->

<!-- TFDOCS_OUTPUTS_START -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.26 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_attachment.asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_elb.elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elb) | resource |
| [aws_route53_record.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_route53_zone.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_route53_zone.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_security_groups.elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_groups) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_inbound_cidr_blocks"></a> [inbound\_cidr\_blocks](#input\_inbound\_cidr\_blocks) | List of CIDR's that are allowed to access the ELB. | `list(string)` | n/a | yes |
| <a name="input_instance_port"></a> [instance\_port](#input\_instance\_port) | On what port does the ELB access the instances. | `number` | n/a | yes |
| <a name="input_lb_port"></a> [lb\_port](#input\_lb\_port) | On what port do you want to access the ELB. | `number` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the ELB and security group resources. | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet ids to place the ELB into. | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC to add this ELB to. | `string` | n/a | yes |
| <a name="input_asg_name"></a> [asg\_name](#input\_asg\_name) | Name of the auto scaling group to attach to. If this value is empty, no attachment will be done and is be left to the end-user via custom 'aws\_autoscaling\_group' or 'aws\_autoscaling\_attachment' definitions. | `string` | `""` | no |
| <a name="input_connection_draining"></a> [connection\_draining](#input\_connection\_draining) | Boolean to enable connection draining. | `bool` | `false` | no |
| <a name="input_connection_draining_timeout"></a> [connection\_draining\_timeout](#input\_connection\_draining\_timeout) | The time in seconds to allow for connections to drain | `number` | `300` | no |
| <a name="input_cross_zone_load_balancing"></a> [cross\_zone\_load\_balancing](#input\_cross\_zone\_load\_balancing) | Enable cross-zone load balancing. | `bool` | `true` | no |
| <a name="input_enable"></a> [enable](#input\_enable) | Whether or not to enable this module. This is required due to the lack of using count for modules. Set it to false to disable the creation of the ELB. Defaults to true | `bool` | `true` | no |
| <a name="input_healthy_threshold"></a> [healthy\_threshold](#input\_healthy\_threshold) | The number of checks before the instance is declared healthy. | `number` | `10` | no |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | The time in seconds that the connection is allowed to be idle. | `number` | `60` | no |
| <a name="input_instance_protocol"></a> [instance\_protocol](#input\_instance\_protocol) | On what protocol does the instance respond. | `string` | `"TCP"` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | If true, ELB will be an internal ELB. | `bool` | `false` | no |
| <a name="input_interval"></a> [interval](#input\_interval) | The interval between checks. | `number` | `30` | no |
| <a name="input_lb_protocol"></a> [lb\_protocol](#input\_lb\_protocol) | On what protocol should the load balancer respond. | `string` | `"TCP"` | no |
| <a name="input_private_dns_evaluate_target_health"></a> [private\_dns\_evaluate\_target\_health](#input\_private\_dns\_evaluate\_target\_health) | Set to true if you want Route 53 to determine whether to respond to DNS queries using this resource record set by checking the health of the resource record set. | `bool` | `true` | no |
| <a name="input_public_dns_evaluate_target_health"></a> [public\_dns\_evaluate\_target\_health](#input\_public\_dns\_evaluate\_target\_health) | Set to true if you want Route 53 to determine whether to respond to DNS queries using this resource record set by checking the health of the resource record set. | `bool` | `true` | no |
| <a name="input_route53_private_dns_name"></a> [route53\_private\_dns\_name](#input\_route53\_private\_dns\_name) | If set, the ELB will be assigned this private DNS name via Route53. | `string` | `""` | no |
| <a name="input_route53_public_dns_name"></a> [route53\_public\_dns\_name](#input\_route53\_public\_dns\_name) | If set, the ELB will be assigned this public DNS name via Route53. | `string` | `""` | no |
| <a name="input_security_group_names"></a> [security\_group\_names](#input\_security\_group\_names) | List of one or more security groups to be added to the load balancer | `list(string)` | `[]` | no |
| <a name="input_sg_name_suffix_elb"></a> [sg\_name\_suffix\_elb](#input\_sg\_name\_suffix\_elb) | Name suffix to append to the ELB security group. | `string` | `"-elb"` | no |
| <a name="input_ssl_certificate_id"></a> [ssl\_certificate\_id](#input\_ssl\_certificate\_id) | "The ARN of an SSL certificate you have uploaded to AWS IAM or<br>ACM. Only valid when lb\_protocol is either HTTPS or SSL" | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all resources. | `map(string)` | `{}` | no |
| <a name="input_target"></a> [target](#input\_target) | The target of the check. If unset, will default to 'instance\_protocol:instance\_port' for TCP/SLL and 'instance\_protocol:instance\_port/' for HTTP/HTTPS. | `string` | `""` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The length of time before the check times out. | `number` | `5` | no |
| <a name="input_unhealthy_threshold"></a> [unhealthy\_threshold](#input\_unhealthy\_threshold) | The number of checks before the instance is declared unhealthy. | `number` | `2` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | The auto-generated FQDN of the ELB. |
| <a name="output_id"></a> [id](#output\_id) | The name of the ELB |
| <a name="output_name"></a> [name](#output\_name) | The name of the ELB |
| <a name="output_route53_private_dns_name"></a> [route53\_private\_dns\_name](#output\_route53\_private\_dns\_name) | The route53 private dns name of the ELB if set. |
| <a name="output_route53_public_dns_name"></a> [route53\_public\_dns\_name](#output\_route53\_public\_dns\_name) | The route53 public dns name of the ELB if set. |
| <a name="output_security_group_ids"></a> [security\_group\_ids](#output\_security\_group\_ids) | The IDs of the ELB security groups to attach the the LC/ASG/EC2 instance in order to be accessable by the ELB. |

<!-- TFDOCS_OUTPUTS_END -->

## Authors

Module managed by [Flaconi](https://github.com/Flaconi).

## License

**[MIT License](LICENSE)**

Copyright (c) 2018-2021 **[Flaconi GmbH](https://github.com/Flaconi)**
