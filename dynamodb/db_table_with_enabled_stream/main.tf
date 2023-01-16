module "dynamodb_table" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name        = "Table B"
  table_class = "STANDARD"
  hash_key    = "trip_id"
  range_key   = "ticket_id"
  billing_mode = "PAY_PER_REQUEST"  #can be set to PROVISIONED. !!! Be carefull with this settings!!!

  global_secondary_indexes = [
    {
      name               = "status-block_timeout-index"
      hash_key           = "status"
      range_key          = "block_timeout"
      projection_type    = "ALL"
    }
  ]
  
  local_secondary_indexes = [
  {
    name               = "transaction_id-index"
    range_key          = "transaction_id"
    projection_type    = "ALL"
  },
  {
    name               = "requester-index"
    range_key          = "requester"
    projection_type    = "ALL"
  }
  ]


# All hash key & range key must be mentioned in the attributes
  attributes = [
    {
      name = "trip_id"
      type = "S"
    },
    {
      name = "ticket_id"
      type = "S"
    },
    {
      name = "transaction_id"
      type = "S"
    },
    {
      name = "requester"
      type = "S"
    },
    {
      name = "status"
      type = "S"
    },
    {
      name = "block_timeout"
      type = "N"
    }
  ]

# Enabling PITR allow us to recover data last 5 min back. must be enabled for backup
point_in_time_recovery_enabled = true

  tags = {
    Name        = "Table B"
    Environment = var.environment
  }
}


# For More information and complete examples: Please visit: 
# https://registry.terraform.io/modules/terraform-aws-modules/dynamodb-table/aws/latest

