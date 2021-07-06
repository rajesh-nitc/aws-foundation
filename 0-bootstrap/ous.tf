# Bootstrap ou
resource "aws_organizations_organizational_unit" "common_ou" {
  name      = "ou-bootstrap"
  parent_id = aws_organizations_organization.org.roots[0].id
}

# Common ou
resource "aws_organizations_organizational_unit" "common" {
  name      = "ou-common"
  parent_id = aws_organizations_organization.org.roots[0].id
}