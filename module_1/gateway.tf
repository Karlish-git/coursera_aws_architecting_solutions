resource "aws_api_gateway_rest_api" "poc_api" {
  name        = "poc_api"
  description = "This is a simple API"  
}

# Create API Gateway POST method
resource "aws_api_gateway_resource" "message_resource" {
  rest_api_id = aws_api_gateway_rest_api.poc_api.id
  parent_id   = aws_api_gateway_rest_api.poc_api.root_resource_id
  path_part   = "message"
}

resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.poc_api.id
  resource_id   = aws_api_gateway_resource.message_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

# # Create integration with SQS
# resource "aws_api_gateway_integration" "sqs_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.poc_api.id
#   resource_id             = aws_api_gateway_resource.message_resource.id
#   http_method             = aws_api_gateway_method.post_method.http_method
#   integration_http_method = "POST"
#   type                   = "AWS"
#   uri                    =aws.sqs_queue.poc_queue.arn
# #   credentials            = var.apigateway_sqs_role_arn
#   passthrough_behavior   = "WHEN_NO_TEMPLATES"

#   request_parameters = {
#     "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
#   }
# }

resource "aws_api_gateway_integration" "sqs_integration" {
  rest_api_id             = aws_api_gateway_rest_api.poc_api.id
  resource_id             = aws_api_gateway_resource.message_resource.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  # Correct URI format for SQS integration
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:sqs:path/${data.aws_caller_identity.current.account_id}/${aws_sqs_queue.poc_queue.name}"
  credentials             = aws_iam_role.api_gateway_sqs_role.arn
  passthrough_behavior    = "NEVER"

  request_parameters = {
    "integration.request.header.Content-Type" = "'application/x-www-form-urlencoded'"
  }

  request_templates = {
    "application/json" = "Action=SendMessage&MessageBody=$util.urlEncode($input.body)"
  }
}

# Add required data source for AWS account ID
data "aws_caller_identity" "current" {}

# Add region data source
data "aws_region" "current" {}

# Add IAM role for API Gateway to access SQS
resource "aws_iam_role" "api_gateway_sqs_role" {
  name = "api_gateway_sqs_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "api_gateway_sqs_policy" {
  name = "api_gateway_sqs_policy"
  role = aws_iam_role.api_gateway_sqs_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:SendMessage"
        ]
        Resource = [
          aws_sqs_queue.poc_queue.arn
        ]
      }
    ]
  })
}

# Method response
resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.poc_api.id
  resource_id = aws_api_gateway_resource.message_resource.id
  http_method = aws_api_gateway_method.post_method.http_method
  status_code = "200"
}

# Integration response
resource "aws_api_gateway_integration_response" "sqs_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.poc_api.id
  resource_id = aws_api_gateway_resource.message_resource.id
  http_method = aws_api_gateway_method.post_method.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code

  depends_on = [
    aws_api_gateway_integration.sqs_integration
  ]
}
