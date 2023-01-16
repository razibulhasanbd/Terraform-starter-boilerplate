variable "lambda_environment_variable" {
    type = string
    description = "A environment variable for lambda"
}

variable "environment" {
    type = string
    description = "release environment name for lambda"
}

variable "event_bus_arn" {
    type = string
}