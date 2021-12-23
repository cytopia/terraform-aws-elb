# -------------------------------------------------------------------------------------------------
# AWS Settings
# -------------------------------------------------------------------------------------------------
provider "aws" {
  region = "eu-central-1"
}

# -------------------------------------------------------------------------------------------------
# VPC Resources
# -------------------------------------------------------------------------------------------------
module "aws_vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v3.11.0"

  cidr            = "14.0.0.0/16"
  azs             = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  private_subnets = ["14.0.10.0/24", "14.0.11.0/24", "14.0.12.0/24"]
  public_subnets  = ["14.0.20.0/24", "14.0.21.0/24", "14.0.22.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  name                = var.name
  public_subnet_tags  = var.public_subnet_tags
  private_subnet_tags = var.private_subnet_tags
}

# -------------------------------------------------------------------------------------------------
# ELB for Bastion Host
# -------------------------------------------------------------------------------------------------
module "elb" {
  source = "../../"

  name       = var.name
  vpc_id     = module.aws_vpc.vpc_id
  subnet_ids = module.aws_vpc.public_subnets

  # Attach to ASG by name
  asg_name = var.name

  # Listener
  lb_port       = 22
  instance_port = 22

  ssl_certificate_id = "arn:aws:acm:eu-central-1:123456789012:certificate/xxxxx-xxxx-xxxx-xxxx-xxxxx"

  # Security
  inbound_cidr_blocks  = ["0.0.0.0/0"]
  security_group_names = ["default"]
}

# -------------------------------------------------------------------------------------------------
# Bastion Host
# -------------------------------------------------------------------------------------------------
data "aws_ami" "bastion" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_launch_configuration" "bastion" {
  name_prefix     = var.name
  image_id        = data.aws_ami.bastion.image_id
  instance_type   = "t2.micro"
  security_groups = module.elb.security_group_ids
  key_name        = var.key_name

  associate_public_ip_address = false

  root_block_device {
    volume_size = "8"
  }
}

resource "aws_autoscaling_group" "bastion" {
  name = var.name

  vpc_zone_identifier = module.aws_vpc.private_subnets

  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 1
  health_check_grace_period = "60"
  health_check_type         = "EC2"
  force_delete              = false
  wait_for_capacity_timeout = 0
  launch_configuration      = aws_launch_configuration.bastion.name
}
