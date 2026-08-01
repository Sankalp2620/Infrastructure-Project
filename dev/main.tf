module "vpc" {
  source = "../Modules/VPC"

  cidr_block           = var.cidr_block
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs

  tags = {
    name = "${var.cluster_name}-vpc-${var.environment}"
  }
}