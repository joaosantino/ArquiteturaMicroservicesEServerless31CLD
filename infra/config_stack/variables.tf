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