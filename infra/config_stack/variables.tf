variable "my_tags" {
  type = map(string)
  default = {}
}

variable "emails" {
  type = list(string)
  default = []
}

variable "lambda_names" {
  type = list(string)
  default = []
}

variable "sns_topic_name" {
  type = string
  default = "Alertas"
}