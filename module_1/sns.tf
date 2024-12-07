# Create the SNS topic
resource "aws_sns_topic" "poc_topic" {
  name = "poc_topic"
}

# Create an email subscription for the topic
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.poc_topic.arn
  protocol  = "email"
endpoint  = "ligtning.uwhsh@aleeas.com"  # Replace with your email address
}

