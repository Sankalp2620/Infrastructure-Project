module "vpc" {
  source = "./Modules/VPC"
  tags   = {}
}

module "iam" {
  source = "./Modules/IAM"
  cluster_name = var.cluster_name
}

module "eks" {
  source = "./Modules/EKS"
  cluster_name       = var.cluster_name
  tags               = {}
  private_subnet_ids = module.vpc.private_subnets
  public_subnet_cidrs = module.vpc.public_subnet_cidrs
  vpc_id             = module.vpc.vpc_id
   //it should also given in terraform.tfvars file
    instance_types     = var.instance_types
}