output "cloudtrail_log_bucket_name" {
  description = "Name of the private S3 bucket that stores CloudTrail logs"
  value       = aws_s3_bucket.cloudtrail_logs.bucket
}

output "cloudtrail_name" {
  description = "Name of the CloudTrail management-events trail"
  value       = aws_cloudtrail.management_events.name
}