#resource "aws_dynamodb_table" "tb_solos" {
#  name = "tb_solos"
#  billing_mode = "PAY_PER_REQUEST"
#  hash_key = "id_solo"
#  attribute {
#    name = "id_solo"
#    type = "S"
#  }
#}