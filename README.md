# Terraform module: AWS ELB

[![Build Status](https://travis-ci.org/cytopia/terraform-aws-elb.svg?branch=master)](https://travis-ci.org/cytopia/terraform-aws-elb)
[![Tag](https://img.shields.io/github/tag/cytopia/terraform-aws-elb.svg)](https://github.com/cytopia/terraform-aws-elb/releases)
[![Terraform](https://img.shields.io/badge/Terraform--registry-aws--elb-brightgreen.svg)](https://registry.terraform.io/modules/cytopia/elb/aws/)
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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| enable | Whether or not to enable this module. This is required due to the lack of using count for modules. Set it to false to disable the creation of the ELB. Defaults to true | string | `"true"` | no |
| vpc\_id | ID of the VPC to add this ELB to. | string | n/a | yes |
| subnet\_ids | List of subnet ids to place the ELB into. | list | n/a | yes |
| asg\_name | Name of the auto scaling group to attach to. If this value is empty, no attachment will be done and is be left to the end-user via custom 'aws_autoscaling_group' or 'aws_autoscaling_attachment' definitions. | string | `""` | no |
| inbound\_cidr\_blocks | List of CIDR's that are allowed to access the ELB. | list | n/a | yes |
| internal | If true, ELB will be an internal ELB. | string | `"false"` | no |
| cross\_zone\_load\_balancing | Enable cross-zone load balancing. | string | `"true"` | no |
| idle\_timeout | The time in seconds that the connection is allowed to be idle. | string | `"60"` | no |
| connection\_draining | Boolean to enable connection draining. | string | `"false"` | no |
| connection\_draining\_timeout | The time in seconds to allow for connections to drain | string | `"300"` | no |
| lb\_port | On what port do you want to access the ELB. | string | n/a | yes |
| instance\_port | On what port does the ELB access the instances. | string | n/a | yes |
| lb\_protocol | On what protocol should the load balancer respond. | string | `"TCP"` | no |
| instance\_protocol | On what protocol does the instance respond. | string | `"TCP"` | no |
| healthy\_threshold | The number of checks before the instance is declared healthy. | string | `"10"` | no |
| unhealthy\_threshold | The number of checks before the instance is declared unhealthy. | string | `"2"` | no |
| target | The target of the check. If unset, will default to 'instance_protocol:instance_port' for TCP/SLL and 'instance_protocol:instance_port/' for HTTP/HTTPS. | string | `""` | no |
| interval | The interval between checks. | string | `"30"` | no |
| timeout | The length of time before the check times out. | string | `"5"` | no |
| name | Name of the ELB and security group resources. | string | n/a | yes |
| tags | Tags to apply to all resources. | map | `<map>` | no |
| sg\_name\_suffix\_elb | Name suffix to append to the ELB security group. | string | `"-elb"` | no |
| security\_group\_names | List of one or more security groups to be added to the load balancer | list(string) | `[]` | no |
| route53\_public\_dns\_name | If set, the ELB will be assigned this public DNS name via Route53. | string | `""` | no |
| route53\_private\_dns\_name | If set, the ELB will be assigned this private DNS name via Route53. | string | `""` | no |
| public\_dns\_evaluate\_target\_health | Set to true if you want Route 53 to determine whether to respond to DNS queries using this resource record set by checking the health of the resource record set. | string | `"true"` | no |
| private\_dns\_evaluate\_target\_health | Set to true if you want Route 53 to determine whether to respond to DNS queries using this resource record set by checking the health of the resource record set. | string | `"true"` | no |
| ssl\_certificate\_id | The ARN of an SSL certificate you have uploaded to AWS IAM or ACM. Only valid when lb_protocol is either HTTPS or SSL. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| security\_group\_ids | The ID of the ELB security group to attach the the LC/ASG/EC2 instance in order to be accessable by the ELB. |
| id | The name of the ELB |
| name | The name of the ELB |
| fqdn | The auto-generated FQDN of the ELB. |
| route53\_public\_dns\_name | The route53 public dns name of the ELB if set. |
| route53\_private\_dns\_name | The route53 private dns name of the ELB if set. |

## Authors

Module managed by [Flaconi](https://github.com/cytopia).

## License

[MIT License](LICENSE)

Copyright (c) 2018-2021 [Flaconi GmbH](https://github.com/Flaconi)
