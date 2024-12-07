resource "aws_iam_role" "lambda_sqs_dynamodb_role" {
  name = "Lambda-SQS-DynamoDB"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_sqs_dynamodb_dynamo_write" {
  role       = aws_iam_role.lambda_sqs_dynamodb_role.name
  policy_arn = aws_iam_policy.lambda_write_dynamodb.arn
}
resource "aws_iam_role_policy_attachment" "lambda_sqs_dynamo_sqs_read" {
  role       = aws_iam_role.lambda_sqs_dynamodb_role.name
  policy_arn = aws_iam_policy.lambda_read_sqs.arn
}


resource "aws_iam_role" "lambda_dynamodbstreams_sns_role" {
  name = "Lambda-DynamoDBStreams-SNS"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "lambda_dynamodbstreams_sns_publish_attachment" {
  role       = aws_iam_role.lambda_dynamodbstreams_sns_role.name
  policy_arn = aws_iam_policy.lambda_sns_publish.arn
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodbstreams_sns_read_attachment" {
  role       = aws_iam_role.lambda_dynamodbstreams_sns_role.name
  policy_arn = aws_iam_policy.lambda_dynamodbstreams_read.arn
}



resource "aws_iam_role" "apigateway_sqs_role" {
  name = "APIGateway-SQS"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "apigateway.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "apigateway_sqs_attachment" {
  role       = aws_iam_role.apigateway_sqs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}