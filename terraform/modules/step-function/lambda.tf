#data "aws_region" "current" {}
#// Create archives for AWS Lambda functions which will be used for Step Function

data "archive_file" "archive-Ami-backup-lambda" {
  type        = "zip"
   source_file = "${var.source-file-path}"
   output_path = "${path.module}/main.zip"
}

data "archive_file" "archive-Launch-EC2-instance-lambda" {
  type        = "zip"
  source_file = "${var.source-file-path-ec2}"
  output_path = "${path.module}/ec2instancecreation.zip"
}

// Create IAM role for AWS Lambda

resource "aws_iam_role" "iam_for_lambda" {
  name = "stepFunctionSampleLambdaIAM"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

// Create AWS Lambda functions

resource "aws_lambda_function" "AMI-Backup-lambda" {
  filename      = "${path.module}/main.zip"
  function_name = "step-functions-AMI-Backup-lambda"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"
  runtime       = "python3.9"
}

resource "aws_lambda_function" "Launch-EC2-Instances-lambda" {
  filename      = "${path.module}/ec2instancecreation.zip"
  function_name = "step-functions-Launch-EC2-Instance"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"
  runtime       = "python3.9"
}