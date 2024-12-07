# Create zip file from function.py
data "archive_file" "lambda_emailer_zip" {
  type        = "zip"
  source_file = "${path.module}/emailer.py"
  output_path = "${path.module}/emailer.zip"
}# Lambda function using the zip

resource "aws_lambda_function" "emailer" {
  filename         = data.archive_file.lambda_emailer_zip.output_path
  source_code_hash = data.archive_file.lambda_emailer_zip.output_base64sha256
  function_name    = "emailer-0"
  role             = aws_iam_role.lambda_dynamodbstreams_sns_role.arn
  handler          = "emailer.mail_handler"
  runtime          = "python3.13"

  environment {
    variables = {
      SNS_TOPIC = aws_sns_topic.poc_topic.arn
    }
  }
}

resource "aws_lambda_event_source_mapping" "emailer_trigger" {
  event_source_arn = aws_dynamodb_table.orders.stream_arn
  function_name    = aws_lambda_function.emailer.arn
  starting_position = "LATEST"
  batch_size = 1
}
