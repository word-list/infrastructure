resource "aws_s3_bucket" "deployment_artifacts" {
  bucket = "${var.project}-${var.environment}-deployment-artifacts"
}

resource "aws_s3_bucket" "source_chunks" {
  bucket = "${var.project}-${var.environment}-source-chunks"
}

resource "aws_s3_bucket" "frontend" {
  bucket = "${var.project}-${var.environment}-frontend"
}

resource "aws_s3_bucket_policy" "cdn_policy" {
  bucket = aws_s3_bucket.frontend.id
  policy = jsonencode({
    Id      = "PolicyForCloudFrontPrivateContent",
    Version = "2008-10-17",
    Statement = [
      {
        Sid       = "1",
        Effect    = "Allow",
        Principal = { AWS = aws_cloudfront_origin_access_identity.oai.iam_arn },
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.frontend.arn}/*"
      }
    ]
  })
}
