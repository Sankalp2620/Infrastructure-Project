output "eks_cluster_role_arn" {
  description = "The ARN of the IAM role for the EKS cluster"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_group_role_arn" {
  description = "The ARN of the IAM role for the EKS node group"
  value       = aws_iam_role.eks_node_group_role.arn
  # Ensure policies are attached before the ARN is used by the node group
  depends_on = [aws_iam_role_policy_attachment.worker_policy]
}