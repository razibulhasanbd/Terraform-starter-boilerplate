variable "environment" {
  type        = string
}
variable "lambda_function_arn" {
  type        = string
  description = "ARN of the teq event lambda function"
}
variable "domain" {
  description = "domain name for each environment"
  default = {
    "dev"     = "dev",
    "test"    = "test",
    "staging" = "staging",
    "prod"    = "nor"
  }
}