# cloudtrail
data "aws_iam_policy_document" "cloudtrail_can_assume_doc" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cloudtrail_assumable_role" {
  name               = "cloudtrail-assumable-role"
  assume_role_policy = data.aws_iam_policy_document.cloudtrail_can_assume_doc.json
}

data "aws_iam_policy_document" "cloudtrail_assumable_role_permissions_doc" {
  statement {
    sid       = "AWSCloudTrailCreateLogStream2014110"
    actions   = ["logs:CreateLogStream"]
    resources = ["arn:aws:logs:${var.region}:${var.management_account_id}:log-group:${aws_cloudwatch_log_group.cloudtrail_events.name}:log-stream:*"]
  }

  statement {
    sid       = "AWSCloudTrailPutLogEvents20141101"
    actions   = ["logs:PutLogEvents"]
    resources = ["arn:aws:logs:${var.region}:${var.management_account_id}:log-group:${aws_cloudwatch_log_group.cloudtrail_events.name}:log-stream:*"]
  }
}

resource "aws_iam_role_policy" "cloudtrail_custom_attach" {
  name   = "cloudtrail-policy"
  role   = aws_iam_role.cloudtrail_assumable_role.id
  policy = data.aws_iam_policy_document.cloudtrail_assumable_role_permissions_doc.json
}

# config
data "aws_iam_policy_document" "config_can_assume_doc" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "config_assumable_role" {
  name               = "config-assumable-role"
  assume_role_policy = data.aws_iam_policy_document.config_can_assume_doc.json
}

data "aws_iam_policy_document" "config_assumable_role_permissions_doc" {
  statement {
    actions = [
      "s3:*"
    ]

    resources = [
      "arn:aws:s3:::${local.config_bucket}",
      "arn:aws:s3:::${local.config_bucket}/*"
    ]

  }
}

resource "aws_iam_role_policy" "config_custom_attach" {
  name   = "config-custom-policy"
  role   = aws_iam_role.config_assumable_role.id
  policy = data.aws_iam_policy_document.config_assumable_role_permissions_doc.json
}

resource "aws_iam_role_policy_attachment" "config_managed_attach" {
  role       = aws_iam_role.config_assumable_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}