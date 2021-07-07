# Seed account
resource "aws_organizations_account" "seed_account" {
  name      = "acc-seed"
  email     = "budita.org.seed@gmail.com"
  parent_id = aws_organizations_organizational_unit.common_ou.id
}

# Logging account: for audit logs and config snapshots
resource "aws_organizations_account" "audit_logs_account" {
  name      = "acc-logging"
  email     = "budita.org.logging@gmail.com"
  parent_id = aws_organizations_organizational_unit.common.id
}

# Network account