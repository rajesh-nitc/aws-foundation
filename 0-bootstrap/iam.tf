# Terraform assumable role in management account
module "terraform_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"
  version = "4.2.0"

  trusted_role_arns = [
    "arn:aws:iam::${data.aws_caller_identity.management_account.account_id}:root",
  ]

  create_admin_role       = true
  admin_role_name         = var.terraform_org_role
  admin_role_requires_mfa = false
}

# org-admin group to assume Terraform role in management and default role in seed
module "org_admins_group_assume_terraform_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"
  version = "4.2.0"

  name = "org-admins-group"

  assumable_roles = [
    module.terraform_role.admin_iam_role_arn,
    "arn:aws:iam::${aws_organizations_account.seed_account.id}:role/OrganizationAccountAccessRole",
    "arn:aws:iam::${aws_organizations_account.audit_logs_account.id}:role/OrganizationAccountAccessRole",

  ]

  group_users = [
    var.admin_user_in_management_account,
  ]
}

