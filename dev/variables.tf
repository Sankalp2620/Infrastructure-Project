variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}
variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  value       = {
    "Environment" = "dev"
    "Project"     = "EKS-Cluster-VPC"
    "name"        = "EKS-Cluster-VPC"
  }
}
variable "region" {
  description = "AWS region"
  type        = string
  value       = "ap-south-2"
}

variable "instance_types" {
  description = "List of EC2 instance types for EKS worker nodes"
  type        = list(string)
  value       = ["t3.medium"]
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  value       = "10.0.0.0/16"
}
variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  value       = ["10.0.1.0/24"]
}
variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  value       = ["10.0.2.0/24"]

}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
}

# These variables are no longer needed here if the IAM module creates them and outputs their ARNs.
# If you still want to define them here for some reason (e.g., for external roles), uncomment and provide values.
# variable "eks_cluster_role_arn" {
#   description = "ARN of the IAM role for the EKS cluster. This role grants EKS permissions to make calls to other AWS services on your behalf."
#   type        = string
# }
#
# variable "node_group_role_arn" {
#   description = "ARN of the IAM role for the EKS node group."
#   type        = string
# }