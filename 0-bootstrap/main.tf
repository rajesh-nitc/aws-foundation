resource "aws_organizations_organization" "org" {
  aws_service_access_principals = [
    "cloudtrail.amazonaws.com",
    "config.amazonaws.com",
  ]

  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
    "TAG_POLICY"
  ]

  feature_set = "ALL"
}

resource "aws_organizations_organizational_unit" "common_ou" {
  name      = "ou-common"
  parent_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_account" "seed_account" {
  name      = "acc-seed"
  email     = "budita.org.seed@gmail.com"
  parent_id = aws_organizations_organizational_unit.common_ou.id
}