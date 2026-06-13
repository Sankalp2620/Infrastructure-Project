

resource "aws_eks_cluster" "maincluster" {
    name     = "${var.cluster_name}-${var.environment}"
    role_arn = var.cluster_role_arn
    version  = var.kubernetes_version

    vpc_config {
        subnet_ids             = var.private_subnet_ids
        endpoint_public_access = var.endpoint_public_access
        endpoint_private_access = var.endpoint_private_access
        public_access_cidrs    = var.public_subnet_cidrs
        security_group_ids     = [aws_security_group.cluster.id]
    }
    enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
    tags                = {
    Environment = var.environment
    Project     = var.cluster_name
  }
}

resource "aws_security_group" "cluster" {
    name = "${var.cluster_name}-cluster-sg-${var.environment}"
    description = "Security group for EKS cluster"
    vpc_id = var.vpc_id

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # In production, restrict this to your VPC or VPN range
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    lifecycle {
      create_before_destroy = true
    }
}

//creating a node group
resource "aws_eks_node_group" "main_node" {
    cluster_name    = aws_eks_cluster.maincluster.name
    node_group_name = "${var.cluster_name}-node-group-${var.environment}"
    node_role_arn   = var.node_group_role_arn
    subnet_ids      = var.private_subnet_ids
    scaling_config {
        desired_size = 2
        max_size     = 3
        min_size     = 1
    }

    instance_types = var.instance_types
}

