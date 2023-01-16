# This file consist of code for creating S3 bucket.
# 

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  # We can specify specific version of the module using version

  bucket = "bucket-unique-name"

  # To make bucket totally private
  acl                     = "private"
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true

  # Set Index document
  website = {
    index_document = "index.html"
  }

  # Ownership of the objects that are being kept in bucket
  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"


  # Versioning. can be enable & paused, can not be disabled. created versions of the objects
  # that are being kept in bucket.
  versioning = {
    enabled = false
  }

  # Encryption of the objects
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  # CORS Rule
  cors_rule = [
    {
      allowed_methods = ["GET", "PUT", "POST", "HEAD"]
      allowed_origins = ["example.com"]
      allowed_headers = ["*"]
      expose_headers  = ["Access-Control-Allow-Origin"]
      max_age_seconds = 3000
    }
  ]

  tags = {
    Name        = "Project name"
    Environment = var.environment                        #variable  passed from the root variables file to S3
  }

}

# Policy for the S3 bucket
data "aws_iam_policy_document" "this" {
  statement {
    actions   = ["s3:GetObject"]                         #Actions allowed in S3 bucket, Get , Put etc.
    resources = ["${module.s3_bucket.s3_bucket_arn}/*"]  #Bucket arn , we can specify folder as well
    principals {
      type        = "AWS"
      identifiers = ["*"]                                #The Resource/User/Service that has the permission for above action
    }
  }
}
# S3 bucket policy must be attached to the bucket via below method
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = module.s3_bucket.s3_bucket_id
  policy = data.aws_iam_policy_document.this.json
}


# For More information and complete examples: Please visit: 
# https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/latest