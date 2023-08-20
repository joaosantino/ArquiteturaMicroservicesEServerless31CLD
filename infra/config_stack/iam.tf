resource "aws_iam_policy" "lambda_app_gerenciasolo_policy" {
  name   = "lambda_app_gerenciasolo_policy"
  policy = file("${path.module}/iam/policies/lambda-app-gerenciasolo-policy.json")
  tags = var.my_tags
}

resource "aws_iam_role" "lambda_app_gerenciasolo_role" {
  depends_on = [aws_iam_policy.lambda_app_gerenciasolo_policy]
  name = "lambda_app_gerenciasolo_role"
  assume_role_policy = file("${path.module}/iam/roles/trust-lambda.json")
  managed_policy_arns = [
    aws_iam_policy.lambda_app_gerenciasolo_policy.arn
  ]
  tags = var.my_tags
}