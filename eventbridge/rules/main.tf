# SQS Queue for DLQ

resource "aws_sqs_queue" "trips" {
  name                      = "dlq_${var.env}_teq_${lookup(var.domain, var.env)}_trip_for_sharebus"
  visibility_timeout_seconds = 30
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 345600
  receive_wait_time_seconds = 0

  sqs_managed_sse_enabled = true

  tags = {
    Environment = var.env
  }
}


resource "aws_sqs_queue_policy" "trips_custom_policy" {

  queue_url = aws_sqs_queue.trips.url

  policy = <<EOF
  {
    "Version": "2008-10-17",
    "Id": " policy",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "events.amazonaws.com"
        },
        "Action": [
          "SQS:*"
        ],
        "Resource": [
          "${aws_sqs_queue.trips.arn}"
        ] 
      }
    ]
  }
  EOF
}

# Cloudwatch log group for eventbridge archieve

resource "aws_cloudwatch_log_group" "eventlogs" {
  name = "/aws/events/${var.env}_sharebus_event_logs"

  tags = {
    Environment = "${var.env}"
  }
}

# Eventbridge

module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  bus_name = "${var.env}-sharebus-event-bus"

  create_schemas_discoverer = false
  create_archives = true
  append_rule_postfix       = false

  rules = {
    trips = {
      description   = "Rule trips"
      event_pattern = file("${path.module}/json/rule_${var.env}_teq_${lookup(var.domain, var.env)}_trip_for_sharebus.json")
    }
    Log-Lambda-events-to-CloudWatch = {
      description   = "Capture log data for ${var.env} sharebus events"
      event_pattern = jsonencode({"account": ["9xxxxxxxxxx"]})
    }

  }


  targets = {
    trips = [
      {
        name = "trips"
        arn = local.lambda_function_arn
      }
    ]
    Log-Lambda-events-to-CloudWatch = [
      {
        name = "send-logs-to-cloudwatch"
        arn  = aws_cloudwatch_log_group.eventlogs.arn
      }
    ]

  }

  archives = {
    "${var.env}-archive" = {
      description    = "${var.env} Event archive",
      retention_days = 90
    }
  }

}

