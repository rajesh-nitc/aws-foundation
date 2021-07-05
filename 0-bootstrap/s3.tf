locals {
  bucket_name = "bkt-tfstate-${random_pet.this.id}"
}

resource "random_pet" "this" {
  length = 2
}

# Allow org admin user to access terraform backend
# Access to group is not supported it seems: Error: Invalid principal in policy
data "aws_iam_policy_document" "bucket_policy" {
  statement {
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.management_account_id}:user/${var.admin_user_in_management_account}",
      ]
    }

    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::${local.bucket_name}",
      "arn:aws:s3:::${local.bucket_name}/*"
    ]
  }
}

module "terraform_state_bucket" {
  providers = {
    aws = aws.seed_account
  }

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.6.0"

  bucket = local.bucket_name
  acl    = "private"

  attach_policy = true
  policy        = data.aws_iam_policy_document.bucket_policy.json

  attach_deny_insecure_transport_policy = true

  versioning = {
    enabled = true
  }

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}