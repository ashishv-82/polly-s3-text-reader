variable "aws_region" {
  type    = string
  default = "ap-southeast-2"
}

variable "project_name" {
  type    = string
  default = "aws-polly-text-narrator"
}

variable "test_text" {
  type    = string
  default = "The Firm follows Matt McDeere, a brilliant young lawyer recruited by an elite Memphis firm that seems too good to be true."
}