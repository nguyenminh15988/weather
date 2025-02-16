terraform {
  required_version = ">= 1.0"
#   backend "s3" {
#     bucket         = "max-weather-tfstate"  # Replace with your S3 bucket name
#     key            = "terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "tf-state-lock"       # Optional: For state locking
#   }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones = ["us-west-2a", "us-west-2b"]
}

module "apigateway" {
  source         = "./modules/apigateway"
  backend_endpoint = "http://${module.alb.alb_dns_name}/weather"  # Replace with your ALB/Nginx endpoint
  authorizer_id  = module.lambda_authorizer.authorizer_id
}

module "eks" {
  source = "./modules/eks"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  cluster_name = var.cluster_name
  cluster_role_arn = var.cluster_role_arn
}
module "alb" {
  source     = "./modules/alb"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets
}

module "cloudwatch" {
  source = "./modules/cloudwatch"
  eks_cluster_name = module.eks.cluster_name
}

module "lambda_authorizer" {
  source = "./modules/lambda-authorizer"
}