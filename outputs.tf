output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}