variable "vpc_id" {
  description = "The VPC ID to use for network resources"
  type        = string
}

variable "public_subnet_ids" {
  description = "The list of public subnet IDs"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
}
