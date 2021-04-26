# -------------------------------------------------------------------------------------------------
# ELB
# -------------------------------------------------------------------------------------------------
resource "aws_elb" "elb" {
  count = "${var.enable ? 1 : 0}"

  name    = "${var.name}"
  subnets = ["${var.subnet_ids}"]

  security_groups = [
    "${aws_security_group.elb.id}",
    "${flatten(data.aws_security_groups.elb.ids)}",
  ]

  internal                    = "${var.internal}"
  cross_zone_load_balancing   = "${var.cross_zone_load_balancing}"
  idle_timeout                = "${var.idle_timeout}"
  connection_draining         = "${var.connection_draining}"
  connection_draining_timeout = "${var.connection_draining_timeout}"

  listener {
    instance_port      = "${var.instance_port}"
    instance_protocol  = "${var.instance_protocol}"
    lb_port            = "${var.lb_port}"
    lb_protocol        = "${var.lb_protocol}"
    ssl_certificate_id = "${var.ssl_certificate_id}"
  }

  health_check {
    healthy_threshold   = "${var.healthy_threshold}"
    unhealthy_threshold = "${var.unhealthy_threshold}"
    timeout             = "${var.timeout}"
    target              = "${local.health_check_target}"
    interval            = "${var.interval}"
  }

  tags = "${merge(map("Name", var.name), var.tags)}"
}

# -------------------------------------------------------------------------------------------------
# Security Groups
# -------------------------------------------------------------------------------------------------
resource "aws_security_group" "elb" {
  count = "${var.enable ? 1 : 0}"

  name_prefix = "${var.name}${var.sg_name_suffix_elb}"
  description = "ELB security group for external connection"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = "${var.lb_port}"
    to_port     = "${var.lb_port}"
    protocol    = "tcp"
    cidr_blocks = "${var.inbound_cidr_blocks}"
    description = "External ELB connection"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "AWS default egress rule"
  }

  revoke_rules_on_delete = true

  # Ensure a new sg is in place before destroying the current one.
  # This will/should prevent any race-conditions.
  lifecycle {
    create_before_destroy = true
  }

  tags = "${merge(var.tags, map("Name", "${var.name}${var.sg_name_suffix_elb}"))}"
}

# -------------------------------------------------------------------------------------------------
# ASG Attachment (Optional)
# -------------------------------------------------------------------------------------------------
resource "aws_autoscaling_attachment" "asg" {
  count = "${var.enable && var.asg_name != "" ? 1 : 0}"

  autoscaling_group_name = "${var.asg_name}"
  elb                    = "${aws_elb.elb.id}"
}

# -------------------------------------------------------------------------------------------------
# Route53 DNS (Optional)
# -------------------------------------------------------------------------------------------------
resource "aws_route53_record" "public" {
  count = "${var.enable && var.route53_public_dns_name != "" ? 1 : 0}"

  zone_id = "${data.aws_route53_zone.public.zone_id}"
  name    = "${var.route53_public_dns_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.elb.dns_name}"
    zone_id                = "${aws_elb.elb.zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "private" {
  count = "${var.enable && var.route53_private_dns_name != "" ? 1 : 0}"

  zone_id = "${data.aws_route53_zone.private.zone_id}"
  name    = "${var.route53_private_dns_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.elb.dns_name}"
    zone_id                = "${aws_elb.elb.zone_id}"
    evaluate_target_health = false
  }
}

data "aws_route53_zone" "public" {
  count = "${var.enable && var.route53_public_dns_name != "" ? 1 : 0}"

  private_zone = false

  # Removes the first sub-domain part from the FQDN to use as hosted zone.
  name = "${replace(var.route53_public_dns_name, "/^.+?\\./", "")}."
}

data "aws_route53_zone" "private" {
  count = "${var.enable && var.route53_private_dns_name != "" ? 1 : 0}"

  private_zone = true

  # Removes the first sub-domain part from the FQDN to use as hosted zone.
  name = "${replace(var.route53_private_dns_name, "/^.+?\\./", "")}."
}
