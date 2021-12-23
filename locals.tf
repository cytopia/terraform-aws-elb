locals {
  health_check_path   = contains(["HTTP", "HTTPS"], var.instance_protocol) ? "/" : ""
  health_check_target = var.target == "" ? "${var.instance_protocol}:${var.instance_port}${local.health_check_path}" : var.target
}
