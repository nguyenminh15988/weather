variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "max-weather-cluster"
}

variable "cluster_role_arn" {
  description = "The ARN of the IAM role to use for the EKS cluster"
  type        = string
   default     = "arn:aws:iam::123456789012:role/eks-cluster-role"  # change this to your IAM role ARN
}