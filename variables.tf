# -------------------------------------------------------------------------------------------------
# Enable/Disable
# -------------------------------------------------------------------------------------------------
variable "enable" {
  description = "Whether or not to enable this module. This is required due to the lack of using count for modules. Set it to false to disable the creation of the ELB. Defaults to true"
  default     = true
}

# -------------------------------------------------------------------------------------------------
# Placement
# -------------------------------------------------------------------------------------------------
variable "vpc_id" {
  description = "ID of the VPC to add this ELB to."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet ids to place the ELB into."
  type        = string
}

# -------------------------------------------------------------------------------------------------
# Attachment (Optional)
# -------------------------------------------------------------------------------------------------
variable "asg_name" {
  description = "Name of the auto scaling group to attach to. If this value is empty, no attachment will be done and is be left to the end-user via custom 'aws_autoscaling_group' or 'aws_autoscaling_attachment' definitions."
  type        = string
  default     = ""
}

# -------------------------------------------------------------------------------------------------
# Access
# -------------------------------------------------------------------------------------------------
variable "inbound_cidr_blocks" {
  description = "List of CIDR's that are allowed to access the ELB."
  type        = list(string)
}

variable "security_group_names" {
  description = "List of one or more security groups to be added to the load balancer"
  type        = list(string)
  default     = []
}

# -------------------------------------------------------------------------------------------------
# ELB Settings (Optional)
# -------------------------------------------------------------------------------------------------
variable "internal" {
  description = "If true, ELB will be an internal ELB."
  type        = bool
  default     = false
}

variable "cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing."
  type        = bool
  default     = true
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle."
  type        = number
  default     = 60
}

variable "connection_draining" {
  description = "Boolean to enable connection draining."
  type        = bool
  default     = false
}

variable "connection_draining_timeout" {
  description = "The time in seconds to allow for connections to drain"
  type        = number
  default     = 300
}

# -------------------------------------------------------------------------------------------------
# Listener
# -------------------------------------------------------------------------------------------------
variable "lb_port" {
  description = "On what port do you want to access the ELB."
  type        = number
}

variable "instance_port" {
  description = "On what port does the ELB access the instances."
  type        = number
}

# -------------------------------------------------------------------------------------------------
# Listener (Optional)
# -------------------------------------------------------------------------------------------------
variable "lb_protocol" {
  description = "On what protocol should the load balancer respond."
  type        = string
  default     = "TCP"
}

variable "instance_protocol" {
  description = "On what protocol does the instance respond."
  type        = string
  default     = "TCP"
}

variable "ssl_certificate_id" {
  description = <<EOF
"The ARN of an SSL certificate you have uploaded to AWS IAM or
ACM. Only valid when lb_protocol is either HTTPS or SSL"
EOF
  type        = string
  default     = ""
}

# -------------------------------------------------------------------------------------------------
# Health Checks (Optional)
# -------------------------------------------------------------------------------------------------
variable "healthy_threshold" {
  description = "The number of checks before the instance is declared healthy."
  type        = number
  default     = 10
}

variable "unhealthy_threshold" {
  description = "The number of checks before the instance is declared unhealthy."
  type        = number
  default     = 2
}

variable "target" {
  description = "The target of the check. If unset, will default to 'instance_protocol:instance_port' for TCP/SLL and 'instance_protocol:instance_port/' for HTTP/HTTPS."
  type        = string
  default     = ""
}

variable "interval" {
  description = "The interval between checks."
  type        = number
  default     = 30
}

variable "timeout" {
  description = "The length of time before the check times out."
  type        = number
  default     = 5
}

# -------------------------------------------------------------------------------------------------
# Naming/Tagging
# -------------------------------------------------------------------------------------------------
variable "name" {
  description = "Name of the ELB and security group resources."
  type        = string
}

# -------------------------------------------------------------------------------------------------
# Naming/Tagging (Optional)
# -------------------------------------------------------------------------------------------------
variable "tags" {
  description = "Tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "sg_name_suffix_elb" {
  description = "Name suffix to append to the ELB security group."
  type        = string
  default     = "-elb"
}

# -------------------------------------------------------------------------------------------------
# DNS (Optional)
# -------------------------------------------------------------------------------------------------
variable "route53_public_dns_name" {
  description = "If set, the ELB will be assigned this public DNS name via Route53."
  type        = string
  default     = ""
}

variable "route53_private_dns_name" {
  description = "If set, the ELB will be assigned this private DNS name via Route53."
  type        = string
  default     = ""
}

variable "public_dns_evaluate_target_health" {
  description = "Set to true if you want Route 53 to determine whether to respond to DNS queries using this resource record set by checking the health of the resource record set."
  type        = bool
  default     = true
}

variable "private_dns_evaluate_target_health" {
  description = "Set to true if you want Route 53 to determine whether to respond to DNS queries using this resource record set by checking the health of the resource record set."
  type        = bool
  default     = true
}
