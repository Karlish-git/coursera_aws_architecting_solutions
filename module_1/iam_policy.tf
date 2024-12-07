data "aws_iam_policy_document" "dynamo_put_policy_document" {
  statement {
    sid = "visualeditor0"

    effect = "Allow"

    actions = [
      "dynamodb:putitem",
      "dynamodb:describetable",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda_write_dynamodb" {
  name        = "Lambda-Write-DynamoDB"
  path        = "/"
  description = "dynamo access put"

  policy = data.aws_iam_policy_document.dynamo_put_policy_document.json
}

resource "aws_iam_policy" "lambda_sns_publish" {
  name = "lambda-sns-publish"

  # terraform's "jsonencode" function converts a
  # terraform expression result to valid json syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "sns:Publish",
          "sns:GetTopicAttributes",
          "sns:ListTopics"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_dynamodbstreams_read" {
  name = "Lambda-DynamoDBStreams-Read"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:GetShardIterator",
          "dynamodb:DescribeStream",
          "dynamodb:ListStreams",
          "dynamodb:GetRecords"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_read_sqs" {
  name = "Lambda-Read-SQS"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : [
          "sqs:DeleteMessage",
          "sqs:ReceiveMessage",
          "sqs:GetQueueAttributes",
          "sqs:ChangeMessageVisibility"
        ],
        "Resource" : "*"
      }
    ]
  })
}