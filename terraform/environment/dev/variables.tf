variable "aws-region" {
  default = "us-west-1"
  type    = string
}

variable "environment-name" {
  default = "dev"
  type    = string
}

variable "standard-tags" {
  type        = map(any)
  description = "Standard tags should be applied to all brink infrastructure resources"
  default = {
    Confidentiality = "C2"
    Environment     = "TEST"
    ManagedBy       = "DL-UKITDigitalDevOps@internal.vodafone.com"
    Project         = "ECare"
    TaggedBy        = "pipeline"
    TaggingVersion  = "V2.4                 "
    #    Digital
    Division     = "co.uk"
    Domain       = "co-uk"
    Program      = "co.uk"
    SecurityZone = "test"
    Service      = "ECare"
  }
}

variable "sfn-role-name" {
  type        = string
  description = "sfn function name"
  default     = "step-Function-ExecutionIAM"
}

variable "sns-policy-name" {
  type        = string
  description = "sns function name"
  default     = "step-Function-Invocation"
}

variable "step-function-name" {
  type        = string
  description = "step function name"
  default     = "state-machine-lambda-invoke"
}

variable "lambda-policy-name" {
  type        = string
  description = "lambda policy name"
  default     = "step-Function-LambdaFunctionInvocation"
}


variable "source-file-path"{
  type = string
  default = "../../../"
}

variable "source-file-path-ec2"{
  type = string
  default = "../../../"
}

variable "sns-iam_sfn_attach_policy_publish_sns-name" {
  type    = string
  default = "sns_iam"
}