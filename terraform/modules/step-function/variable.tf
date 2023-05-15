variable "aws_region" {
  type        = string
  description = "Specified AWS Region"
  default     = "us-east-1"
}

variable "sfn-role-name" {
  type = string
}

variable "sns-policy-name" {
  type = string
}

variable "step-function-name" {
  type = string
}

variable "lambda-policy-name" {
  type = string
}

variable "standard-tags" {
  type = map(any)
}

variable "sns-iam_sfn_attach_policy_publish_sns-name" {
  type = string
}

variable "source-file-path"{
  type = string
}

variable "source-file-path-ec2"{
  type = string
}