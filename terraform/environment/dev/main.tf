module "step-function-lambda-image-creation" {
  source = "../../modules/step-function"

  #environment_name   = var.environment_name
  standard-tags = var.standard-tags
  #aws-region         = var.aws-region
  sfn-role-name                              = var.sfn-role-name
  sns-policy-name                            = var.sns-policy-name
  step-function-name                         = var.step-function-name
  lambda-policy-name                         = var.lambda-policy-name
  sns-iam_sfn_attach_policy_publish_sns-name = var.sns-iam_sfn_attach_policy_publish_sns-name
  source-file-path     = "${var.source-file-path}/main.py"
  source-file-path-ec2 = "${var.source-file-path-ec2}/LaunchEC2.py"
}

module "s3-bucket" {
  source            = "../../modules/s3-bucket"
  environment-name  = var.environment-name
  standard-tags     = var.standard-tags
  bucket-name       = "co-uk-s3-backend-terraform"
}