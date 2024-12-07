resource "aws_dynamodb_table" "orders" {
  name         = "orders"
  billing_mode = "PAY_PER_REQUEST" # On-demand capacity mode
  stream_enabled = true
  stream_view_type = "NEW_IMAGE"

  hash_key = "orderID"

  attribute {
    name = "orderID"
    type = "S" # String
  }

  tags = {
    Name = "orders"
  }
}
