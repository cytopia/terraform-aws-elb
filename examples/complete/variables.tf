variable "name" {
  description = "The name(-prefix) to prepend/apply to all Name tags on all VPC resources"
  default     = "elb-complete"
}

variable "public_subnet_tags" {
  description = "A map of additional tags to apply to all public subnets"
  type        = map(string)

  default = {
    Visibility = "public"
  }
}

variable "private_subnet_tags" {
  description = "A map of additional tags to apply to all private subnets"
  type        = map(string)

  default = {
    Visibility = "private"
  }
}

variable "key_name" {
  description = "Name of SSH key on AWS"
  default     = ""
}
