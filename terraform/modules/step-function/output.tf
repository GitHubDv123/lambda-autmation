output "ami_lambda_function_arn" {
  value = aws_lambda_function.AMI-Backup-lambda.arn
}

output "launch_lambda_function_arn" {
  value = aws_lambda_function.Launch-EC2-Instances-lambda.arn
}