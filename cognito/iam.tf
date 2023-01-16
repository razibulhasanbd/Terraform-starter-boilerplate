
resource "aws_iam_role" "sns" {
  name        = "sharebus_sms_role_${var.environment}"
  path        = "/ShareBus/"
  description = "SNS Role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "1",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cognito-idp.amazonaws.com"
        },
        "Action" : "sts:AssumeRole",
        "Condition" : {
          "StringEquals" : {
            "sts:ExternalId" : "${var.externalid}"
          }
        }
      }
    ]
  })

}

resource "aws_iam_role_policy" "sns_policy" {
  name = "sns_inline_policy_${var.environment}"
  role = aws_iam_role.sns.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "sns:publish"
        ],
        "Resource" : [
          "*"
        ]
      }
    ]
  })
}


# # Role for Federated Identity Policy

# resource "aws_iam_policy" "federated_identities_authenticated_policy" {
#   name        = "${var.environment}_federated_identities_policy"
#   path        = "/"
#   description = "Policy for federated identities"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "mobileanalytics:PutEvents",
#           "cognito-sync:*",
#           "cognito-identity:*"
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       },
#       {
#         Action = [
#           "s3:GetObject",
#           "s3:PutObject",
#           "s3-object-lambda:*"
#         ]
#         Effect   = "Allow"
#         Resource = "*"
#       },
#     ]
#   })
# }

# resource "aws_iam_role" "federated_identities_authenticated_role" {
#   name = "${var.environment}_federated_identities_role"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRoleWithWebIdentity"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Federated = "cognito-identity.amazonaws.com"
#         }
#         Condition = {
#           "StringEquals" : {
#             "cognito-identity.amazonaws.com:aud" : "${aws_cognito_identity_pool.this.id}"
#           },
#           "ForAnyValue:StringLike" : {
#             "cognito-identity.amazonaws.com:amr" : "authenticated"
#           }
#         }
#       },
#     ]
#   })

#   tags = {
#     tag-key = "${var.environment}_federated_identities_role"
#   }
# }
# resource "aws_iam_role_policy_attachment" "federated_identities" {
#   policy_arn = aws_iam_policy.federated_identities_authenticated_policy.arn
#   role       = aws_iam_role.federated_identities_authenticated_role.name
# }