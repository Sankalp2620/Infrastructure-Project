variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "my-eks-cluster"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "instance_types" {
  description = "List of EC2 instance types for EKS worker nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
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