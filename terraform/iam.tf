data "aws_iam_policy_document" "lambda_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Create role if doesn't exist, ignore changes if it does
resource "aws_iam_role" "polly_translation" {
  name               = "PollyTranslationRole"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json

  lifecycle {
    ignore_changes = all
  }
}

locals {
  polly_role_arn  = aws_iam_role.polly_translation.arn
  polly_role_name = aws_iam_role.polly_translation.name
}

resource "aws_iam_role_policy_attachment" "polly_full_access" {
  role       = local.polly_role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonPollyFullAccess"
}

resource "aws_iam_role_policy_attachment" "s3_full_access" {
  role       = local.polly_role_name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = local.polly_role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}