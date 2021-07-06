output "seed_account_id" {
  value = aws_organizations_account.seed_account.id
}

output "audit_logs_account_id" {
  value = aws_organizations_account.audit_logs_account.id
}

output "terraform_state_bucket" {
  value = module.terraform_state_bucket.s3_bucket_id
}

output "caller_identity" {
  value = data.aws_caller_identity.management_account
}

output "org_id" {
  value = aws_organizations_organization.org.roots[0].id
}