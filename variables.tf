# variable "put any name". We can put any name for variables, but the naming must be consistent
# across the application.

variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "eu-west-1"
}

variable "lambda_environment_variable" {
  type        = string
  default     = "A"
  description = "A environment variable for lambda"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "release environment name"
}

variable "deployment_stage_name" {
  type    = string
  default = "dev"
}

variable "api_name" {
  type        = string
  default     = "demo_api_gateway"
  description = "Api name demo-serverless"
}

variable "allow_origin" {
  type    = string
  default = "*"
}
