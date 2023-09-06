resource "aws_sqs_queue" "terraform_queue" {
  name                      = "envia-requisicao"
  max_message_size          = 2048
  message_retention_seconds = 345600
  sqs_managed_sse_enabled = true
  policy = file("${path.module}/iam/policies/sqs-default-policy.json")

  tags = var.my_tags
}

output "sqs_id" {
  value = aws_sqs_queue.terraform_queue.id
}