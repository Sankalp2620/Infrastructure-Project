resource "aws_s3_bucket" "terraform_state" {
  bucket = "Add-bucket-name"

  lifecycle {
    prevent_destroy = false
  }
}


terraform {  
  backend "s3" {  
    bucket       = var.s3_bucket_name  
    key          = "terraform.tfstate"
    region       = var.region  
    encrypt      = true  
    use_lockfile = true  #S3 native locking
  }  
}

module "vpc" {
  source = "./Modules/VPC"
  tags   = {
    name = "${var.cluster_name}-vpc-${var.environment}"
  }
}

module "iam" {
  source = "./Modules/IAM"
  cluster_name = "${var.cluster_name}-vpc-${var.environment}"
}

module "eks" {
  source = "./Modules/EKS"
  cluster_name        = "${var.cluster_name}-vpc-${var.environment}"
  # It's good practice to pass common tags to all modules
  tags                = {
    Environment = var.environment
    Project     = var.cluster_name
  }
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_cidrs = module.vpc.public_subnet_cidrs
  vpc_id             = module.vpc.vpc_id
  instance_types     = var.instance_types
  cluster_role_arn    = module.iam.eks_cluster_role_arn # Get ARN from IAM module output
  node_group_role_arn = module.iam.eks_node_group_role_arn # Get ARN from IAM module output
  environment         = var.environment
}