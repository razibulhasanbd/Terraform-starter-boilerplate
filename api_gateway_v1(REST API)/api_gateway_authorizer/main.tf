#api gateway authorizer
resource "aws_api_gateway_authorizer" "authorizer" {
   name          = "authorizer"
   rest_api_id   = var.api_gateway_id
   type          = "COGNITO_USER_POOLS"
   provider_arns = ["${var.cognito_arn}"]
}
