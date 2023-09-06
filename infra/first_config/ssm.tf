resource "aws_ssm_parameter" "secret" {
  name        = "/app-dynamostream/SNSTopicARN"
  description = "Parametro que contém o ARN do Tópico SNS"
  type        = "SecureString"
  value       = aws_sns_topic.sns_topic_alertas.id

  tags = var.my_tags
}