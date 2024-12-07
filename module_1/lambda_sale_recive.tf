# Create zip file from function.py
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/function.py"
  output_path = "${path.module}/function.zip"
}

# Lambda function using the zip
resource "aws_lambda_function" "order_processor" {
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  function_name    = "POC-Lambda-1"
  role             = aws_iam_role.lambda_sqs_dynamodb_role.arn
  handler          = "function.lambda_handler"
  runtime          = "python3.13"

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.orders.name
    }
  }
}

resource "aws_lambda_event_source_mapping" "sqs_order_processor_trigger" {
  event_source_arn = aws_sqs_queue.poc_queue.arn
  function_name    = aws_lambda_function.order_processor.arn
  batch_size       = 1
}
