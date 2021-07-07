resource "random_pet" "config" {
  length = 2
}

data "aws_iam_policy_document" "config_bucket_policy" {
  statement {
    principals {
      type = "Service"
      identifiers = [
        "config.amazonaws.com",
      ]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      "arn:aws:s3:::${local.config_bucket}",
      "arn:aws:s3:::${local.config_bucket}/*"
    ]
  }
}

module "config_bucket" {
  providers = {
    aws = aws.audit_logs_account
  }

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.6.0"

  bucket = local.config_bucket
  acl    = "private"

  attach_policy = true
  policy        = data.aws_iam_policy_document.config_bucket_policy.json

  attach_deny_insecure_transport_policy = true

  lifecycle_rule = [
    {
      id      = "auto-archive"
      enabled = true
      prefix  = "/"

      transition = [
        {
          days          = 30
          storage_class = "ONEZONE_IA"
        },
        {
          days          = 60
          storage_class = "GLACIER"
        }
      ]
    }
  ]

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}