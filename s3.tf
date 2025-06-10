resource "aws_s3_bucket" "deployment_artifacts" {
  bucket = "${var.project}-${var.environment}-deployment-artifacts"
}

resource "aws_s3_bucket" "source_chunks" {
  bucket = "${var.project}-${var.environment}-source-chunks"
}

resource "aws_s3_bucket" "frontend" {
  bucket = "${var.project}-${var.environment}-frontend"
}
