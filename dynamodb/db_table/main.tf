module "dynamodb_table" {
  source    = "terraform-aws-modules/dynamodb-table/aws"
  name      = "Table-A"
  hash_key  = "PK-1"
  range_key = "PK-2"
  table_class = "STANDARD"
  billing_mode = "PAY_PER_REQUEST"  #can be set to PROVISIONED. !!! Be carefull with this settings!!!

# Enabling PITR allow us to recover data last 5 min back. must be enabled for backup
  point_in_time_recovery_enabled = true

  attributes = [
    {
      name = "PK-1"
      type = "S"
    },
    {
      name = "PK-2"
      type = "S"
    }

  ]

  tags = {
    Name = "Table-A"
    Environment  = var.environment
  }
}


# For More information and complete examples: Please visit: 
# https://registry.terraform.io/modules/terraform-aws-modules/dynamodb-table/aws/latest