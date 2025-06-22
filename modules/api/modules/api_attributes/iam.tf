resource "aws_iam_role" "api_attributes" {
  name = "${var.project}-${var.environment}-api-attributes-role"

  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF  
}

resource "aws_iam_role_policy_attachment" "api_attributes_deployment_artifacts" {
  policy_arn = var.deployment_artifacts_bucket_policy_arn
  role       = aws_iam_role.api_attributes.name
}

resource "aws_iam_role_policy_attachment" "api_attributes_basic_logging" {
  role       = aws_iam_role.api_attributes.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "word_attributes_table" {
  role       = aws_iam_role.api_attributes.name
  policy_arn = var.word_attributes_table_policy_arn
}
