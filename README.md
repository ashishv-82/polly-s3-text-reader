
# AWS Polly S3 Text Reader

This project provides an automated way to convert text to speech using AWS Polly, store the resulting audio in an S3 bucket, and manage all infrastructure using Terraform.

## Features

- **AWS Lambda** function (Node.js) that uses AWS Polly to synthesize speech from text and saves the audio file to S3.
- **S3 Bucket** for storing generated audio files.
- **IAM Role** with required permissions for Lambda, Polly, and S3.
- **Terraform** for infrastructure as code, with idempotent resource creation (won’t recreate S3 bucket or IAM role if they already exist).

## Project Structure

```
.
├── lambda/
│   └── index.js           # Lambda function code
├── terraform/
│   ├── iam.tf
│   ├── lambda.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── variables.tf
│   └── ...
└── README.md
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.5.0
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- Node.js (for Lambda code, if you want to modify/test locally)

## Setup & Deployment

1. **Configure AWS credentials**  
	Make sure your AWS CLI is configured:
	```bash
	aws configure
	```

2. **Deploy infrastructure**
	```bash
	cd terraform
	terraform init
	terraform plan
	terraform apply
	```

3. **Outputs**
	- `audio_bucket_name`: The S3 bucket where audio files are stored.
	- `lambda_response`: The result of a test Lambda invocation.

## How it Works

- The Lambda function takes input text, uses AWS Polly to generate speech, and uploads the audio file to the S3 bucket (`polly-audio-files-folder`).
- The S3 bucket and IAM role are only created if they do not already exist.
- The Lambda function and its permissions are managed by Terraform.

## Customization

- Change the test text or voice in `terraform/variables.tf`.
- Modify the Lambda code in `lambda/index.js` as needed.

## Cleanup

To destroy all resources created by this project:
```bash
cd terraform
terraform destroy
```

## License

MIT

