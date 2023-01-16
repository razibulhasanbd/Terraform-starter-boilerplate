# api gateway resource
resource "aws_api_gateway_resource" "api_gateway_resource" {
  rest_api_id = var.api_gateway_id
  parent_id   = var.api_gateway_root
  path_part   = "child-path" # need to configure as your api endpoint
}

# api gateway method
# api gateway method depends on api gateway resource
resource "aws_api_gateway_method" "api_gateway_method" {
  rest_api_id      = var.api_gateway_id
  resource_id      = aws_api_gateway_resource.api_gateway_resource.id
  http_method      = "GET" # need to configure as your method type
  authorization    = "NONE"
  depends_on = [
    aws_api_gateway_resource.api_gateway_resource
  ]
}

# lambda permission to allow api gateway trigger
# It's better to allow lambda permission after the api gateway meathod creation
resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowMyDemoAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${var.api_gateway_source_arn}/*/GET/parent-path/child-path" # need to configure as your api gateway method type and endpoint path
  depends_on = [
    aws_api_gateway_method.api_gateway_method
  ]
}

# api gateway integration with lambda function
# api gateway intregration depends on api gateway method and associated lambda's trigger permission
resource "aws_api_gateway_integration" "api_gateway_request_integration" {
  rest_api_id             = var.api_gateway_id
  resource_id             = aws_api_gateway_resource.api_gateway_resource.id
  http_method             = aws_api_gateway_method.api_gateway_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = var.lambda_invoke_arn
  depends_on = [
    aws_api_gateway_method.api_gateway_method,
    aws_lambda_permission.lambda_permission
  ]
  
}

# api gateway integration response from lambda function
# api gateway intregration response depends on api gateway intregration
resource "aws_api_gateway_integration_response" "api_gateway_integration_response" {
  rest_api_id = var.api_gateway_id
  resource_id = aws_api_gateway_resource.api_gateway_resource.id
  http_method = aws_api_gateway_method.api_gateway_method.http_method
  status_code = aws_api_gateway_method_response.api_gateway_method_response_200.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'${var.allow_origin}'"
  }
  depends_on = [
    aws_api_gateway_integration.api_gateway_request_integration
  ]
}

# api gateway method response
# api gateway method response depends on api gateway method
resource "aws_api_gateway_method_response" "api_gateway_method_response_200" {
  rest_api_id = var.api_gateway_id
  resource_id = aws_api_gateway_resource.api_gateway_resource.id
  http_method = aws_api_gateway_method.api_gateway_method.http_method
  status_code = "200"
  
  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
  depends_on  = [ aws_api_gateway_method.api_gateway_method]
}

# api gateway deployment
# api gateway deployment must be triggered when the avobe resources are created
resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  rest_api_id       = var.api_gateway_id
  stage_name        = var.deployment_stage_name
  stage_description = "Deployed at: ${timestamp()}"

  depends_on = [
      aws_api_gateway_integration_response.api_gateway_integration_response,
      aws_api_gateway_method_response.api_gateway_method_response_200
  ]
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.api_gateway_resource,
      aws_api_gateway_method.api_gateway_method,
      aws_api_gateway_integration.api_gateway_request_integration,
      aws_api_gateway_integration_response.api_gateway_integration_response,
      aws_api_gateway_method_response.api_gateway_method_response_200
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

#enabling CORS for this single resource
module "cors" {
  source = "squidfunk/api-gateway-enable-cors/aws"

  api_id          = var.api_gateway_id
  api_resource_id = aws_api_gateway_resource.api_gateway_resource.id
}