locals {
  logs_bucket   = "bkt-logs-${random_pet.this.id}"
  config_bucket = "bkt-config-${random_pet.config.id}"
  ou_ids        = [for i in data.aws_organizations_organizational_units.ou.children : i.id]
}