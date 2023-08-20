resource "aws_lambda_function" "lambda" {
  for_each      = toset(var.lambda_names)
  function_name = each.value
  runtime       = "python3.9"
  handler       = "lambda_function.lambda_handler"
  timeout       = 30
  role          = aws_iam_role.lambda_app_gerenciasolo_role.arn
  s3_bucket     = aws_s3_bucket.bucket.bucket
  s3_key        = "apps/${each.value}/${each.value}.zip"
  tracing_config {
    mode = "Active"
  }
  tags = var.my_tags
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  for_each          = toset(var.lambda_names)
  name              = "/aws/lambda/${each.value}"
  retention_in_days = 14
}

output "lambdas" {
  value =  [
    for lambda in aws_lambda_function.lambda : lambda.arn
  ]
}