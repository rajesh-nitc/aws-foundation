# Must be in management account
resource "aws_cloudtrail" "org" {
  name                       = "org-cloudtrail"
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail_events.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudwatch_delivery.arn
  is_organization_trail      = true
  s3_bucket_name             = module.audit_logs_bucket.s3_bucket_id
  s3_key_prefix              = "audit-logs"
}

# Must be in management account
resource "aws_cloudwatch_log_group" "cloudtrail_events" {
  name              = "cloudtrail-events"
  retention_in_days = 5
}
