data "aws_security_groups" "elb" {
  count = length(var.security_group_names) >= 1 ? 1 : 0

  filter {
    name   = "group-name"
    values = [element(var.security_group_names, count.index)]
  }

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}
