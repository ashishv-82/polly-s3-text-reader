resource "aws_s3_bucket" "audio" {
  bucket = "polly-audio-files-folder"

  lifecycle {
    ignore_changes = all
  }
}

locals {
  audio_bucket_name = aws_s3_bucket.audio.id
}