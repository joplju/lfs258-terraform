variable "home_ip_cidr" {
  # This is a variable to keep it protected.
  description = "Personal home IP in CIDR notation"
  type        = string
  validation {
    condition     = can(cidrhost(var.home_ip_cidr, 0))
    error_message = "Must be a valid IPv4 CIDR"
  }
}

variable "num_controllers" {
  default     = 1
  description = "Number of controller Droplets to create"
  type        = number
}

variable "num_workers" {
  default     = 2
  description = "Number of worker Droplets to create"
  type        = number
}

variable "vpc_cidr" {
  default     = "172.16.0.0/24"
  description = "CIDR of the cluster VPC"
  type        = string
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Must be a valid IPv4 CIDR"
  }
}
