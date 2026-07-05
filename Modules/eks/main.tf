# Eks main cluster module
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
    depends_on = [
        aws_iam_role_policy_attachment.eks_policy,
        aws_iam_role_policy_attachment.worker_policy
    ]

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
resource "aws_eks_node_group" "eks-worker-node" {
    cluster_name    = aws_eks_cluster.eks-worker-node.name
    node_group_name = "${var.cluster_name}-eks-worker-node-${var.environment}"
    node_role_arn   = var.node_group_role_arn
    subnet_ids      = var.private_subnet_ids
    capacity_type  = var.capacity_type
    instance_types = var.instance_types
    scaling_config {
        desired_size = 2
        max_size     = 3
        min_size     = 1
    }

    depends_on = [
    aws_iam_role_policy_attachment.eks_node_policy
  ]


}

# internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id
  tags   = var.tags
}

# Elastic IPs
resource "aws_eip" "eip-nat" {
  domain = "vpc"
  count= aws_subnet.publicsubnet.*.id
}

# Nat Gateway
resource "aws_nat_gateway" "nat-gw" {
  count         = length(aws_subnet.publicsubnet.*.id)
  allocation_id = aws_eip.eip-nat[count.index].id
  subnet_id     = aws_subnet.publicsubnet[count.index].id
  tags          =  {
    Name = "nat-gateway-${count.index + 1}"
  }
}

# public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.eks_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.tags["name"]}-public-route-table"
  }
}

# private route table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.eks_vpc.id
  count = length(aws_subnet.privatesubnet.*.id)
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw[count.index].id
  }
  tags = {
    Name = "${var.tags["name"]}-private-route-table-${count.index + 1}"
  }
}

# Public route table association
resource "aws_route_table_association" "public_route_table_association" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.publicsubnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
  tags = {
    Name = "${var.tags["name"]}-public-route-table-association-${count.index + 1}"
  }
}

# Private route table association
resource "aws_route_table_association" "private_route_table_association" {
  count          = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.privatesubnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
  tags = {
    Name = "${var.tags["name"]}-private-route-table-association-${count.index + 1}"
  }
}


