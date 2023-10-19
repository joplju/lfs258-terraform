variable "home_ip" {
  description = "Personal home IP; using a variable to keep it protected"
  type        = string
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
  default     = "10.255.0.0/16"
  description = "CIDR of the cluster VPC"
  type        = string
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Must be a valid IPv4 CIDR"
  }
}
