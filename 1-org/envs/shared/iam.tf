data "aws_iam_policy_document" "cloudwatch_delivery_assume_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cloudwatch_delivery" {
  name               = "cloudwatch-delivery-role"
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_delivery_assume_policy.json
}

data "aws_iam_policy_document" "cloudwatch_delivery_policy" {
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

resource "aws_iam_role_policy" "cloudwatch_delivery_policy" {
  name   = "cloudwatch-delivery-policy"
  role   = aws_iam_role.cloudwatch_delivery.id
  policy = data.aws_iam_policy_document.cloudwatch_delivery_policy.json
}