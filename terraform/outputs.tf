output "audio_bucket_name" {
  value = local.audio_bucket_name
}

output "lambda_response" {
  value = aws_lambda_invocation.test.result
}