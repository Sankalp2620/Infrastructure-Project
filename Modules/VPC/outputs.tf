output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.EKS_VPC.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.publicsubnet[*].id
}

output "public_subnet_cidrs" {
  description = "The CIDR blocks of the public subnets"
  value       = aws_subnet.publicsubnet[*].cidr_block
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.privatesubnet[*].id
}

output "private_subnet_cidrs" {
  description = "The CIDR blocks of the private subnets"
  value       = aws_subnet.privatesubnet[*].cidr_block
}
