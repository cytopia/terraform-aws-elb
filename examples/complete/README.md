# Complete ELB example

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run terraform destroy when you don't need these resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| key_name | Name of SSH key on AWS | string | `` | no |
| name | The name(-prefix) to prepend/apply to all Name tags on all VPC resources | string | `elb-complete` | no |
| private_subnet_tags | A map of additional tags to apply to all private subnets | map | `<map>` | no |
| public_subnet_tags | A map of additional tags to apply to all public subnets | map | `<map>` | no |
