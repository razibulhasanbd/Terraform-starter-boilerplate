variable "environment" {
  type        = string
  description = "release environment name"
}

variable "mail" {
  description = "mail for each environment"
  default = {
    "dev"     = "dev",
    "test"    = "test",
    "staging" = "staging",
    "prod"    = "production"
  }
}