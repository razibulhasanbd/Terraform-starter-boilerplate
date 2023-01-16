data "aws_region" "current" {}

# API
resource "aws_appsync_graphql_api" "this" {
  authentication_type = "AMAZON_COGNITO_USER_POOLS"
  name                = "Name for the appasync"

  user_pool_config {
    aws_region     = data.aws_region.current.name
    default_action = "ALLOW"
    user_pool_id   = "cognito user pool ID must be passed"
  }
  additional_authentication_provider {
    authentication_type = "API_KEY"
  }

  log_config {
    cloudwatch_logs_role_arn = aws_iam_role.appsync-log-role.arn
    field_log_level          = "ALL"
  }
}

# API Key
resource "aws_appsync_api_key" "this" {
  api_id  = aws_appsync_graphql_api.this.id
  expires = "2023-11-13T01:00:00Z"
}

# Need to change this API key every time it expires