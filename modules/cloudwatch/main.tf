resource "aws_cloudwatch_log_group" "eks_logs" {
  name = "/aws/eks/${var.eks_cluster_name}/cluster"
}