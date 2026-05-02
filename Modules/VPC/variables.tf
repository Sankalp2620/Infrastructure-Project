variable "cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/22"
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
}
