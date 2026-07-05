
s3_bucket_name = "my-terraform-state-eksbucket-dev"
cluster_name = "my-eks-cluster"
instance_types = ["t3.medium"]
region= "ap-south-1"
environment = "dev"

cidr_block = "10.0.0.0/16"

private_subnet_cidrs = [
  "10.0.3.0/24",
  "10.0.4.0/24"
]

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]