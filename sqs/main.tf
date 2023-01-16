resource "aws_sqs_queue" "demo-dlq" {
  name                      = "demo-dlq"
  delay_seconds             = 10
  max_message_size          = 262144
  message_retention_seconds = 345600
  receive_wait_time_seconds = 10

  tags = {
    Env = "${var.environment}"
  }
}

output "dlq_arn" {
  value= aws_sqs_queue.demo-dlq.arn
}


resource "aws_sqs_queue" "demo" {
  name                      = "demo"
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 345600
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.demo-dlq.arn
    maxReceiveCount     = 4
  })

  depends_on = [
    aws_sqs_queue.demo-dlq
  ]

  tags = {
    Env = "${var.environment}"
  }
}

resource "aws_lambda_event_source_mapping" "source_mapping" {
  event_source_arn = aws_sqs_queue.demo.arn
  enabled          = true
  function_name    = var.lambda_function_arn
  batch_size       = 1
}
