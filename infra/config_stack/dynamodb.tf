resource "aws_dynamodb_table" "tb_solos" {
  name             = "tb_solos"
  billing_mode     = "PAY_PER_REQUEST"
  hash_key         = "id_solo"
  range_key        = "id_cultivo"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  attribute {
    name = "id_solo"
    type = "N"
  }

  attribute {
    name = "id_cultivo"
    type = "N"
  }
}

output "table_name_2" {
  value = aws_dynamodb_table.tb_solos.name
}