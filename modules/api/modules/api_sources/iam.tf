resource "aws_iam_role" "api_sources" {
  name = "${var.project}-${var.environment}-api-sources-role"

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

resource "aws_iam_role_policy_attachment" "api_sources_table" {
  role       = aws_iam_role.api_sources.name
  policy_arn = var.sources_table_policy_arn
}

resource "aws_iam_role_policy_attachment" "api_sources_deployment_artifacts" {
  policy_arn = var.deployment_artifacts_bucket_policy_arn
  role       = aws_iam_role.api_sources.name
}

resource "aws_iam_role_policy_attachment" "api_sources_basic_logging" {
  role       = aws_iam_role.api_sources.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
