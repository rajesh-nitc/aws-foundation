locals {
  env_code = element(split("", var.env), 0)
}

resource "aws_organizations_organizational_unit" "ou" {
  name      = "ou-${var.env}"
  parent_id = data.aws_organizations_organization.org.roots[0].id
}

# Shared vpc account
resource "aws_organizations_account" "account" {
  name      = "acc-${local.env_code}-network"
  email     = var.network_account_email
  parent_id = aws_organizations_organizational_unit.ou.id
}