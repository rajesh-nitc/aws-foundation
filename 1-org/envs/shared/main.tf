locals {
  bucket_name = "bkt-logs-${random_pet.this.id}"
  ou_ids      = [for i in data.aws_organizations_organizational_units.ou.children : i.id]
}