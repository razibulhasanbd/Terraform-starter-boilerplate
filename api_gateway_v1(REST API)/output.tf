output "api_gateway_id" {
  value= aws_api_gateway_rest_api.api_gateway.id
}

output "api_gateway-arn" {
  value= aws_api_gateway_rest_api.api_gateway.arn
}

output "api_gateway_body" {
  value= aws_api_gateway_rest_api.api_gateway.arn
}

output "api_gateway_root" {
  value=aws_api_gateway_rest_api.api_gateway.root_resource_id
}

output "api_gateway_source_arn" {
  value= aws_api_gateway_rest_api.api_gateway.execution_arn
}