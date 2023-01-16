variable "environment_variables" {
  description = "mapping for lambda environment variables"
  default = {
    "dev" = {
      DOMAIN = "dev"
    },

    "test" = {
      DOMAIN = "test"
    }

    "staging" = {
      DOMAIN = "staging"
    }

    "prod" = {
      DOMAIN = "nor"
    }
  }
}

variable "environment" {
  type        = string
  description = "release environment name for lambda"
}
variable "apigateway_connected_lambda_arn" {
  type        = string
  description = "ARN of the lambda function"
}