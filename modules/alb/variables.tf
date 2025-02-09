variable "vpc_id" {
  description = "The VPC ID where the ALB will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "The list of subnet IDs where the ALB will be deployed"
  type        = list(string)
}