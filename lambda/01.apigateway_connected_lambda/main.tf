module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "apigateway_connected_lambda2"
  description   = "My apigateway_connected_lambda lambda function"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  timeout       = 3

  source_path = "lambda/01.apigateway_connected_lambda/src"
  # Merging local  variables (e.g lambda arns) & some environment variables
  environment_variables = merge(local.var_env, lookup(var.environment_variables, var.env))

  layers = [
    "layer ARN"
  ]

  tags = {
    Name = "apigateway_connected_lambda2"
    Env  = "${var.environment}"
  }

}

resource "aws_iam_policy" "policy" {
  name        = "${var.environment}_apigateway_connected_lambda2_policy"
  path        = "/"
  description = "lambda Role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "apigateway:*"
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

output "lambda_invoke_arn" {
  value = module.lambda_function.lambda_function_invoke_arn
}

output "lambda_name" {
  value = module.lambda_function.lambda_function_name
}