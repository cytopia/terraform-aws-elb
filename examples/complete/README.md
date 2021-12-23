# Complete ELB example

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run terraform destroy when you don't need these resources.

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_vpc"></a> [aws\_vpc](#module\_aws\_vpc) | github.com/terraform-aws-modules/terraform-aws-vpc | v3.11.0 |
| <a name="module_elb"></a> [elb](#module\_elb) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_launch_configuration.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) | resource |
| [aws_ami.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name(-prefix) to prepend/apply to all Name tags on all VPC resources | `string` | `"elb-complete"` | no |
| <a name="input_public_subnet_tags"></a> [public\_subnet\_tags](#input\_public\_subnet\_tags) | A map of additional tags to apply to all public subnets | `map(string)` | <pre>{<br>  "Visibility": "public"<br>}</pre> | no |
| <a name="input_private_subnet_tags"></a> [private\_subnet\_tags](#input\_private\_subnet\_tags) | A map of additional tags to apply to all private subnets | `map(string)` | <pre>{<br>  "Visibility": "private"<br>}</pre> | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Name of SSH key on AWS | `string` | `""` | no |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
