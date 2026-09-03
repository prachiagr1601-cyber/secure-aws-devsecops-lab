resource "aws_sns_topic" "security_alerts" {
  name = "${var.project_name}-security-alerts"

  tags = {
    Project     = var.project_name
    Environment = "lab"
    ManagedBy   = "terraform"
  }
}

resource "aws_sns_topic_subscription" "security_alert_email" {
  topic_arn = aws_sns_topic.security_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_event_rule" "high_risk_security_changes" {
  name        = "${var.project_name}-high-risk-security-changes"
  description = "Detects high-risk IAM, CloudTrail, S3, and KMS configuration changes"

  event_pattern = jsonencode({
    source = [
      "aws.iam",
      "aws.cloudtrail",
      "aws.s3",
      "aws.kms"
    ]

    detail-type = [
      "AWS API Call via CloudTrail"
    ]

    detail = {
      eventSource = [
        "iam.amazonaws.com",
        "cloudtrail.amazonaws.com",
        "s3.amazonaws.com",
        "kms.amazonaws.com"
      ]

      eventName = [
        "AttachRolePolicy",
        "PutRolePolicy",
        "CreateAccessKey",
        "StopLogging",
        "DeleteTrail",
        "PutBucketPolicy",
        "DeletePublicAccessBlock",
        "PutKeyPolicy",
        "DisableKey"
      ]
    }
  })

  tags = {
    Project     = var.project_name
    Environment = "lab"
    ManagedBy   = "terraform"
  }
}

resource "aws_cloudwatch_event_target" "send_security_alert_email" {
  rule = aws_cloudwatch_event_rule.high_risk_security_changes.name
  arn  = aws_sns_topic.security_alerts.arn
}

resource "aws_sns_topic_policy" "allow_eventbridge_publish" {
  arn = aws_sns_topic.security_alerts.arn

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowEventBridgeToPublish"
        Effect = "Allow"

        Principal = {
          Service = "events.amazonaws.com"
        }

        Action   = "sns:Publish"
        Resource = aws_sns_topic.security_alerts.arn

        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_cloudwatch_event_rule.high_risk_security_changes.arn
          }
        }
      }
    ]
  })
}