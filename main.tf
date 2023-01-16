# Below is an example of terraform block. When we run terraform command from local machine, 
# The block will be like this. This will be different if we use remote backend for storing our terraform 
# State. 

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# The region can also set in variable and pass to this provider block. 
# The Profile for Provider is basically aws profile that you set for using via aws cli. 
# Example command: "aws s3 ls --profile sandbox"
# Here, sandbox is profile , that consist of access key & secret key for accessing aws account.

provider "aws" {
  region  = "Please put region e.g eu-west-1"
  profile = "Please put you aws profile here e.g sandbox"
}


# Below Blocks are for resources. In below blocks, we will mention module.Basically module is like 
# packages, That was created by others and published. 
# we can also create our custom module if require.
# If we want to pass any variables for any resources, we must declare the variable in root variables.tf
# and then pass on the module mentioned in main.tf
# e.g we want to pass environment, we can manually change in every file , or we can set variable
# var.env or var.environment, add it in root variable.tf, pass it in module.
# Important: any variable that are passed from main.tf must be mentioned inside resources variables.tf 
# we can set default value in either variables.tf file.

# S3 Bucket
module "s3_bucket" {
  source      = "./s3"
  environment = var.environment
}

# cognito user pool 
module "cognito" {
  source      = "./cognito"
  environment = var.environment
}

#dynamoDB
module "dynamodb_table" {
  source      = "./dynamodb/db_table"
  environment = var.environment
}

#DynamoDB table with enabled stream
module "dynamodb_table_enabled_stream" {
  source      = "./dynamodb/db_table_with_enabled_stream"
  environment = var.environment
}



# api gateway connected lambda function
module "apigateway_connected_lambda" {
  source                      = "./lambda/00.apigateway_connected_lambda"
  environment                 = var.environment
  lambda_environment_variable = var.lambda_environment_variable
}

# api gateway connected lambda function
module "apigateway_connected_lambda2" {
  source                          = "./lambda/01.apigateway_connected_lambda"
  environment                     = var.environment
  apigateway_connected_lambda_arn = module.apigateway_connected_lambda.lambda_function_arn
}

# eventbridge connected lambda function
module "eventbridge_connected_lambda" {
  source                      = "./lambda/eventbridge_connected_lambda"
  environment                 = var.environment
  lambda_environment_variable = var.lambda_environment_variable
  event_bus_arn               = module.eventbridge_bus.eventbridge_rule_arns["orders"]
}

# sqs connected lambda function
module "sqs_connected_lambda" {
  source                      = "./lambda/sqs_connected_lambda"
  environment                 = var.environment
  lambda_environment_variable = var.lambda_environment_variable
}

# Eventbridge Rules & Schedules

# Event Bridge Rules
module "eventbridgerules" {
  source      = "./eventbridge/rules"
  lambda_arn  = module.eventbridge_connected_lambda.lambda_arn
  environment = var.environment
}
module "eventbridgeschedules" {
  source      = "./eventbridge/schedules"
  lambda_arn  = module.eventbridge_connected_lambda.lambda_arn
  environment = var.environment
}


module "sqs" {
  source              = "./sqs"
  lambda_function_arn = module.sqs_connected_lambda.lambda_arn
  environment         = var.environment
  depends_on = [
    module.sqs_connected_lambda
  ]
}


# api gateway
module "api_gateway" {
  source   = "./api_gateway"
  api_name = var.api_name
}

# api gateway authorizer
module "api_gateway_authorizer" {
  source         = "./api_gateway/api_gateway_authorizer"
  cognito_arn    = module.cognito.cognito_arn
  api_gateway_id = module.api_gateway.api_gateway_id
}

# api gateway nested resource under root resource
resource "aws_api_gateway_resource" "api_gateway_parent_resource" {
  rest_api_id = module.api_gateway.api_gateway_id
  parent_id   = module.api_gateway.api_gateway_root
  path_part   = "parent-path" # need to configure as your api endpoint
}

# api gateway resource under nested resource
module "api_gateway_child_resource" {
  source                 = "./api_gateway/api_gateway_resource"
  api_gateway_id         = module.api_gateway.api_gateway_id
  api_gateway_root       = aws_api_gateway_resource.api_gateway_parent_resource.id
  api_gateway_source_arn = module.api_gateway.api_gateway_source_arn
  lambda_invoke_arn      = module.apigateway_connected_lambda.lambda_invoke_arn
  lambda_name            = module.apigateway_connected_lambda.lambda_name
  deployment_stage_name  = var.deployment_stage_name
  allow_origin           = var.allow_origin
  depends_on = [
    module.api_gateway,
    aws_api_gateway_resource.api_gateway_parent_resource,
    module.apigateway_connected_lambda
  ]
}

# api gateway authorized resource under root resource
module "api_gateway_resource_with_authorized_method" {
  source                 = "./api_gateway/api_gateway_resource_with_authorized_method"
  api_gateway_id         = module.api_gateway.api_gateway_id
  api_gateway_root       = module.api_gateway.api_gateway_root
  api_gateway_source_arn = module.api_gateway.api_gateway_source_arn
  lambda_invoke_arn      = module.apigateway_connected_lambda2.lambda_invoke_arn
  lambda_name            = module.apigateway_connected_lambda2.lambda_name
  deployment_stage_name  = var.deployment_stage_name
  allow_origin           = var.allow_origin
  authorizer_id          = module.api_gateway_authorizer.authorizer_id
  depends_on = [
    module.api_gateway,
    module.apigateway_connected_lambda2
  ]
}

