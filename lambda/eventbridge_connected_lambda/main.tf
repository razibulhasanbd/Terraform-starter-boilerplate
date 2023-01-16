module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "eventbridge_connected_lambda"
  description   = "My eventbridge_connected_lambda lambda function"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  timeout       = 3

  source_path = "lambda/eventbridge_connected_lambda/src"
  create_current_version_allowed_triggers = false
  environment_variables = {
    lambda_environment_variable=var.lambda_environment_variable
  }

  allowed_triggers = {
    OneRule = {
      principal  = "events.amazonaws.com"
      source_arn = var.event_bus_arn
    }
  }
  
  tags = {
    Name = "eventbridge_connected_lambda"
    Env= "${var.environment}"
  }

}

resource "aws_iam_policy" "policy" {
  name        = "${var.environment}_eventbridge_connected_lambda_lambda_policy"
  path        = "/"
  description = "lambda Role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "events:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
     {
        Action = [
          "logs:CreateLogGroup",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "role-attach" {
  role       = module.lambda_function.lambda_role_name
  policy_arn = aws_iam_policy.policy.arn
}

output "lambda_arn" {
  value=module.lambda_function.lambda_function_arn
}

output "lambda_invoke_arn" {
  value= module.lambda_function.lambda_function_invoke_arn
}

output "lambda_name" {
  value= module.lambda_function.lambda_function_name
}