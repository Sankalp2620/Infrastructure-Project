resource "aws_eks_cluster" "maincluster" {
    name     = var.cluster_name
    role_arn = var.cluster_name
    version  = var.kubernetes_version
    
    vpc_config {
        subnet_ids = var.private_subnet_ids
        endpoint_public_access = var.endpoint_public_access
        endpoint_private_access = var.endpoint_private_access
        public_access_cidrs = var.public_subnet_cidrs
        security_group_ids = [aws_security_group.cluster_sg.id]
    }
    enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
    tags = var.tags
}



resource "aws_security_group" "cluster" {
    name_prefix = "${var.cluster_name}-cluster-sg"
    description = "Security group for EKS cluster"
    vpc_id = var.vpc_id
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    lifecycle {
      create_before_destroy = true
    }

}

//creating a node group
resource "aws_eks_node_group" "main_node" {
    cluster_name = aws_eks_cluster.maincluster.name
    node_group_name = "${var.cluster_name}-node-group"
    node_role_arn = aws_iam_role.mode_role.arn
    subnet_ids = var.private_subnet_ids
    scaling_config {
        desired_size = 2
        max_size = 3
        min_size = 1
    }

    instance_types = var.instance_types
    
    //i need to add the policy which are added in th IAM "node_policy" in depends_on
    depends_on = [aws_iam_role_policy_attachment.node_policy]

}
