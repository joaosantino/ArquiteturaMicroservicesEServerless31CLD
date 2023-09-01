resource "aws_sns_topic" "sns_topic_alertas" {
  name = var.sns_topic_name
  tags = var.my_tags
  tracing_config = "Active"
  kms_master_key_id = "alias/aws/sns"
}

#resource "aws_sns_topic_policy" "sns_topic_alertas_policy" {
#  depends_on = [aws_iam_policy.sns_topic_alertas_policy]
#  arn        = aws_sns_topic.sns_topic_alertas.arn
#  policy     = aws_iam_policy.sns_topic_alertas_policy.policy
#}

resource "aws_sns_topic_subscription" "sns_topic_alertas_subscription" {
  for_each  = toset(var.emails)
  endpoint  = each.value
  protocol  = "email"
  topic_arn = aws_sns_topic.sns_topic_alertas.arn
  endpoint_auto_confirms = true
}