data "aws_iam_policy_document" "sample_policy_doc" {
  statement {
    sid    = "DenyS3BucketsPublicAccess"
    effect = "Deny"
    actions = [
      "s3:PutBucketPublicAccessBlock",
      "s3:DeletePublicAccessBlock"
    ]
    resources = ["*"]
  }

  statement {
    sid       = "DenyLeavingOrgs"
    effect    = "Deny"
    actions   = ["organizations:LeaveOrganization"]
    resources = ["*"]
  }
}

resource "aws_organizations_policy" "sample_scp" {
  name        = "sample-scp"
  description = "Sample SCP"
  content     = data.aws_iam_policy_document.sample_policy_doc.json
}

resource "aws_organizations_policy_attachment" "ous" {
  for_each  = toset(local.ou_ids)
  policy_id = aws_organizations_policy.sample_scp.id
  target_id = each.value
}