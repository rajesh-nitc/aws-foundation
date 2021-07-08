data "aws_iam_policy_document" "assume_role" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${aws_organizations_account.account.id}:role/OrganizationAccountAccessRole"]
  }
}

resource "aws_iam_policy" "this" {
  name        = "policy-${local.env_code}-network"
  description = "Allows org admins group to assume role in another AWS account"
  policy      = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_group_policy_attachment" "this" {
  group      = var.org_group_name
  policy_arn = aws_iam_policy.this.id
}