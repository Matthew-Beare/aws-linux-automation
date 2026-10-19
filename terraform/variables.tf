variable "region" { type = string }
variable "vpc_id" { type = string }
variable "subnet_id" { type = string }
variable "ec2_key_name" { type = string }

variable "admin_cidr" {
  type = string
  validation {
    condition     = can(cidrnetmask(var.admin_cidr)) && can(regex("/32$", var.admin_cidr))
    error_message = "For this lab, SSH must be limited to a single IPv4 /32 address."
  }
}

variable "instances" {
  type = map(object({
    ami_id        = string
    instance_type = string
  }))
}
