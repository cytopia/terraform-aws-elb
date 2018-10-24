# Terraform module: AWS ELB

This Terraform module creates an ELB with optionally a public and/or private Route53 DNS record attached to it.
Additionally it provides the option to attach the created ELB to an autoscaling group by name.


## Usage

```hcl
module "elb" {
  source  = "github.com/cytopia/terraform-aws-elb?ref=v0.1.0"

  name       = "my-elb"
  vpc_id     = "vpc-12345"
  subnet_ids = ["subnet-1234", "subnet-5677"]

  # Attach the ELB to an ASG by this name
  asg_name = "my-service"

  # Listener
  lb_port       = "443"
  instance_port = "80"

  # Security
  inbound_cidr_blocks = ["0.0.0.0/0"]

  # Create this route53 public DNS record
  public_dns_name = "my-service.example.com"
}
```

## Examples

* [Complete ELB](examples/complete/)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| vpc_id | ID of the VPC to add this ELB to. | string | - | yes |
| subnet_ids | List of subnet ids to place the ELB into. | list | - | yes |
| asg_name | Name of the auto scaling group to attach to. If this value is empty, no attachment will be done and is be left to the end-user via custom 'aws_autoscaling_group' or 'aws_autoscaling_attachment' definitions. | string | `` | no |
| inbound_cidr_blocks | List of CIDR's that are allowed to access the ELB. | list | - | yes |
| internal | If true, ELB will be an internal ELB. | string | `false` | no |
| cross_zone_load_balancing | Enable cross-zone load balancing. | string | `true` | no |
| idle_timeout | The time in seconds that the connection is allowed to be idle. | string | `60` | no |
| connection_draining | Boolean to enable connection draining. | string | `false` | no |
| connection_draining_timeout | The time in seconds to allow for connections to drain | string | `300` | no |
| lb_port | On what port do you want to access the ELB. | string | - | yes |
| instance_port | On what port does the ELB access the instances. | string | - | yes |
| lb_protocol | On what protocol should the load balancer respond. | string | `TCP` | no |
| instance_protocol | On what protocol does the instance respond. | string | `TCP` | no |
| healthy_threshold | The number of checks before the instance is declared healthy. | string | `10` | no |
| unhealthy_threshold | The number of checks before the instance is declared unhealthy. | string | `2` | no |
| target | The target of the check. If unset, will default to 'instance_protocol:instance_port' for TCP/SLL and 'instance_protocol:instance_port/' for HTTP/HTTPS. | string | `` | no |
| interval | The interval between checks. | string | `30` | no |
| timeout | The length of time before the check times out. | string | `5` | no |
| name | Name of the ELB and security group resources. | string | - | yes |
| tags | Tags to apply to all resources. | map | `<map>` | no |
| sg_name_suffix_elb | Name suffix to append to the ELB security group. | string | `-elb` | no |
| route53_public_dns_name | If set, the ELB will be assigned this public DNS name via Route53. | string | `` | no |
| route53_private_dns_name | If set, the ELB will be assigned this private DNS name via Route53. | string | `` | no |
| public_dns_evaluate_target_health | Set to true if you want Route 53 to determine whether to respond to DNS queries using this resource record set by checking the health of the resource record set. | string | `true` | no |
| private_dns_evaluate_target_health | Set to true if you want Route 53 to determine whether to respond to DNS queries using this resource record set by checking the health of the resource record set. | string | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| security_group_id | The ID of the ELB security group to attach the the LC/ASG/EC2 instance in order to be accessable by the ELB. |
| id | The name of the ELB |
| name | The name of the ELB |
| fqdn | The auto-generated FQDN of the ELB. |
| route53_public_dns_name | The route53 public dns name of the ELB if set. |
| route53_private_dns_name | The route53 private dns name of the ELB if set. |

## Authors

Module managed by [cytopia](https://github.com/cytopia).

## License

[MIT License](LICENSE)

Copyright (c) 2018 [cytopia](https://github.com/cytopia)
