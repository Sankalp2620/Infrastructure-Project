variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version to use for the cluster"
  type        = string
  default     = "1.27"
}

variable "vpc_id" {
  description = "VPC ID where the cluster will be deployed"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks of public subnets (for security group ingress)"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
}

variable "endpoint_public_access" {
    description = "Whether to enable public access to the EKS cluster endpoint"
    type        = bool
    default     = false
  
}
variable "endpoint_private_access" {
    description = "Whether to enable private access to the EKS cluster endpoint"
    type        = bool
    default     = true
}

variable "instance_types" {
    description = "List of EC2 instance types for the node group"
    type        = list(string)
}

variable "cluster_role_arn" {
    description = "ARN of the IAM role for the EKS cluster"
    type        = string  
}

variable "node_group_role_arn" {
    description = "ARN of the IAM role for the EKS node group"
    type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}
