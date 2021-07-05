output "seed_account_id" {
  value = aws_organizations_account.seed_account.id
}

output "terraform_state_bucket" {
  value = module.terraform_state_bucket.s3_bucket_id
}

output "caller_identity" {
  value = data.aws_caller_identity.management_account
}