resource "aws_sqs_queue" "poc_queue" {
  name = "poc_queue_private_karlitos"
}

# Create Queue Policy
resource "aws_sqs_queue_policy" "poc_queue_policy" {
  queue_url = aws_sqs_queue.poc_queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.apigateway_sqs_role.arn
        }
        Action = [
          "sqs:SendMessage"
        ]
        Resource = aws_sqs_queue.poc_queue.arn
      },
      {
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.lambda_sqs_dynamodb_role.arn
        }
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = aws_sqs_queue.poc_queue.arn
      }
    ]
  })
}