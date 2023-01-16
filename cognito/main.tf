# Cognito user pool
module "cognito-user-pool" {
  source = "lgallard/cognito-user-pool/aws"

  # We can specify specific version of the module using version

  user_pool_name = "user pool name"

  # Username attributes, can be only email or email , phone number
  username_attributes = ["email", "phone_number"]
  # Attributes that we want to verified
  auto_verified_attributes = ["email", "phone_number"]

  # MFA Configuraion, can be set to ON, OFF & OPTIONAL
  mfa_configuration = "OPTIONAL"
  # Important to set up, for preventing accidental deletion
  deletion_protection = "ACTIVE"

  sms_authentication_message = "example message. must have this:  {####}."
  sms_verification_message   = "example message. must have this:  {####}."
  email_verification_message = "example message. must have this:  {####}."
  email_verification_subject = "Subject"

  admin_create_user_config = {
    allow_admin_create_user_only = false    #Can be set to true, if only admin allowed to create user
    email_message                = "example message. must have this:  {####}."
    email_subject                = "Subject"
    sms_message                  = "example message. must have this:  {####}."

  }
  # Password policy for the users
  password_policy = {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7

  }

  # Email Configuration. can be set to COGNITO_DEFAULT to use cognito mail service, recommended
  # to USE SES service like below
  email_configuration = {
    email_sending_account = "DEVELOPER"
    from_email_address    = "${lookup(var.mail, var.environment)}" #To set email sender depending on the environment
    source_arn            = "SES ARN"
    configuration_set     = "Configuration set name"
  }

  # Verification Message template
  verification_message_template = {
    default_email_option = "CONFIRM_WITH_CODE"    #can be set to CONFIRM_WITH_LINK
    email_message        = "example message. must have this:  {####}."
    email_subject        = "Subject"
    sms_message          = "example message. must have this:  {####}."

  }


  #User account recovery
  recovery_mechanisms = [{
    name     = "verified_email"
    priority = 1
  }]


  # identity_providers 3rd Party e.g Google
  identity_providers = [
    {
      provider_name = "Google"
      provider_type = "Google"

      provider_details = {
        authorize_scopes              = "email openid profile"    #Authorization scopes
        client_id                     = "Client ID from google"
        client_secret                 = "Client Secret from google"
        attributes_url                = "https://people.googleapis.com/v1/people/me?personFields="
        attributes_url_add_attributes = "true"
        authorize_url                 = "https://accounts.google.com/o/oauth2/v2/auth"
        oidc_issuer                   = "https://accounts.google.com"
        token_request_method          = "POST"
        token_url                     = "https://www.googleapis.com/oauth2/v4/token"
      }

      attribute_mapping = {
        email          = "email"
        email_verified = "email_verified"
        name           = "name"
        username       = "sub"
      }
    }

  ]

  # schema for email , username & profilecomplete

  string_schemas = [
    {
      attribute_data_type      = "String"
      developer_only_attribute = false
      mutable                  = true
      name                     = "email"
      required                 = true

      string_attribute_constraints = {
        min_length = 5
        max_length = 50
      }
    },
    {
      attribute_data_type      = "String"
      developer_only_attribute = false
      mutable                  = true
      name                     = "name"
      required                 = false

      string_attribute_constraints = {
        min_length = 3
        max_length = 50
      }
    }
  ]
  number_schemas = [
    {
      attribute_data_type      = "Number"
      developer_only_attribute = false
      mutable                  = true
      name                     = "isProfileComplete"
      required                 = false

      number_attribute_constraints = {
        min_value = 0
        max_value = 1
      }
    }
  ]

  sms_configuration_external_id    = var.externalid
  sms_configuration_sns_caller_arn = aws_iam_role.sns.arn

  domain = "Domain for the app"

  clients = [
    {
      allowed_oauth_flows                  = ["code"]
      allowed_oauth_flows_user_pool_client = true
      allowed_oauth_scopes                 = ["email", "openid", "phone", "profile", "aws.cognito.signin.user.admin"]
      callback_urls                        = "Callback URLs for the application"
      default_redirect_uri                 = "Redirect URLs for the application"
      explicit_auth_flows                  = ["ALLOW_CUSTOM_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_PASSWORD_AUTH", "ALLOW_USER_SRP_AUTH"]
      generate_secret                      = false
      logout_urls                          = "Logout URLs for the application"
      name                                 = "name of the client/application"
      read_attributes                      = ["Read attributes for the cognito", "e.g gender", "given_name", "locale", "middle_name", "name", "nickname", "phone_number", "phone_number_verified", "picture", "preferred_username", "profile", "updated_at", "website", "zoneinfo"]
      supported_identity_providers         = ["COGNITO", "Google"]    #Identity providers
      write_attributes                     = ["Write attributes e.g address", "birthdate", "email", "custom:isProfileComplete", "family_name", "gender", "given_name", "locale", "middle_name", "name", "nickname", "phone_number", "picture", "preferred_username", "profile", "updated_at", "website", "zoneinfo"]
      access_token_validity                = 1
      id_token_validity                    = 1
      refresh_token_validity               = 30
      token_validity_units = {
        access_token  = "hours"
        id_token      = "hours"
        refresh_token = "days"
      }
      prevent_user_existence_errors = "ENABLED"
    },
  ]


  # tags
  tags = {
    Name        = "Project name"
    Environment = var.environment                        #variable  passed from the root variables file to S3
  }
}


# For creating federate identities
# Federate identity

# resource "aws_cognito_identity_pool" "this" {
#   identity_pool_name               = "federated_identities"
#   allow_unauthenticated_identities = false
#   cognito_identity_providers {
#     client_id               = module.cognito-user-pool.client_ids[0]
#     provider_name           = module.cognito-user-pool.endpoint
#     server_side_token_check = true
#   }
# }

# output "aws_cognito_identity_pool" {
#   value = aws_cognito_identity_pool.this.id
# }

# # Role Attachment

# resource "aws_cognito_identity_pool_roles_attachment" "this" {
#   identity_pool_id = aws_cognito_identity_pool.this.id

#   roles = {
#     "authenticated" = aws_iam_role.federated_identities_authenticated_role.arn

#   }
# }


# For More information and complete examples: Please visit: 
# https://registry.terraform.io/modules/lgallard/cognito-user-pool/aws/latest