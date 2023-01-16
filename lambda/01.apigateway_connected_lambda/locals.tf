locals {
  var_env = {
    ENV                             = "${var.env}"
    apigateway_connected_lambda_arn = var.apigateway_connected_lambda_arn
  }
}