# Package lambda code
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda"
  output_path = "${path.module}/.build/lambda.zip"
}

resource "aws_lambda_function" "polly_to_s3" {
  function_name    = "TTSPollyTranslationFunction"
  role             = local.polly_role_arn
  handler          = "index.handler"
  runtime          = "nodejs20.x"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout          = 30
  memory_size      = 256

  environment {
    variables = {
      OUTPUT_BUCKET = local.audio_bucket_name
    }
  }
}

# Invoke Lambda with test text during apply (RequestResponse)
resource "aws_lambda_invocation" "test" {
  function_name = aws_lambda_function.polly_to_s3.function_name

  input = jsonencode({
    text    = var.test_text
    voiceId = "Joanna"
  })

  triggers = {
    test_text_hash = sha256(var.test_text)
  }

  lifecycle {
    replace_triggered_by = [aws_lambda_function.polly_to_s3]
  }
}