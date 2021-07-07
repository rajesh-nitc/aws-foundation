resource "aws_config_delivery_channel" "this" {
  name           = "org-config-delivery-channel"
  s3_bucket_name = module.config_bucket.s3_bucket_id
  s3_key_prefix  = "config"
  depends_on     = [aws_config_configuration_recorder.this]
}

resource "aws_config_configuration_recorder" "this" {
  name     = "org-config-recorder"
  role_arn = aws_iam_role.config_assumable_role.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_configuration_recorder_status" "this" {
  name       = aws_config_configuration_recorder.this.name
  is_enabled = true
  depends_on = [aws_config_delivery_channel.this]
}

resource "aws_config_configuration_aggregator" "org" {
  depends_on = [
    aws_config_configuration_recorder_status.this,
    aws_iam_role_policy_attachment.aggregator_managed_attach,
  ]

  name = "aggregator-all-regions"

  organization_aggregation_source {
    all_regions = true
    role_arn    = aws_iam_role.aggregator_can_assume_role.arn
  }
}

resource "aws_iam_role" "aggregator_can_assume_role" {
  name = "aggregator-role"
  path = "/service-role/"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "aggregator_managed_attach" {
  role       = aws_iam_role.aggregator_can_assume_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRoleForOrganizations"
}