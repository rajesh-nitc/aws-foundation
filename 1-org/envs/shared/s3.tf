locals {
  bucket_name = "bkt-logs-${random_pet.this.id}"
}

resource "random_pet" "this" {
  length = 2
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    principals {
      type = "Service"
      identifiers = [
        "cloudtrail.amazonaws.com",
      ]
    }

    actions = [
      "s3:*"
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_name}",
      "arn:aws:s3:::${local.bucket_name}/*"
    ]
  }
}

module "audit_logs_bucket" {
  providers = {
    aws = aws.audit_logs_account
  }

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.6.0"

  bucket = local.bucket_name
  acl    = "private"

  attach_policy = true
  policy        = data.aws_iam_policy_document.bucket_policy.json

  attach_deny_insecure_transport_policy = true

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
