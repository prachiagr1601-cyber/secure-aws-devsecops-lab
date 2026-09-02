variable "aws_region" {
  description = "AWS region for regional resources."
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Non-personal tag used to identify lab resources."
  type        = string
  default     = "secure-aws-devsecops-lab"
}