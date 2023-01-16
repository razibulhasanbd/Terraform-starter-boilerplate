# Role for the event schedule
resource "aws_iam_role" "schedule" {
  name        = "schedule_role"
  path        = "/"
  description = "Schedule Role for BE"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "scheduler.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
})

}

resource "aws_iam_policy" "schedule_policy" {
  name        = "schedule_custom_policy"
  path        = "/"
  description = "attach Invoke permission with Role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "lambda:InvokeFunction"
        ],
        Resource = [
          local.lambda_arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "role-attach" {
  role       = aws_iam_role.schedule.name
  policy_arn = aws_iam_policy.schedule_policy.arn
}



resource "aws_scheduler_schedule" "cancellation" {
  name       = "cancellation-tf"
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }
  schedule_expression_timezone = "Europe/Oslo"
  schedule_expression = "cron(0 11 * * ? *)"

  target {
    arn      = local.lambda_arn
    role_arn = aws_iam_role.schedule.arn
  }
}
