resource "aws_sns_topic" "sns_topic_alertas" {
  name = "Alertas"
  tags = var.my_tags
  tracing_config = "Active"
  kms_master_key_id = "alias/aws/sns"
}

resource "aws_sns_topic_subscription" "sns_topic_alertas_subscription" {
  for_each  = toset(var.emails)
  endpoint  = each.value
  protocol  = "email"
  topic_arn = aws_sns_topic.sns_topic_alertas.arn
  endpoint_auto_confirms = true
}