
## step function - Terraform Module

### Description
This Terraform project will step function and flow to trigger the lambda function.


### Usage:

To set up the defined Storage module Resources:

``` terraform
module "step-function-lambda-image-creation" {
  source = "../../modules/step-function"

  standard-tags                              = < Base resource tags >
  sfn-role-name                              = step-Function-ExecutionIAM
  sns-policy-name                            = step-Function-Invocation
  step-function-name                         = state-machine-lambda-invoke
  lambda-policy-name                         = step-Function-LambdaFunctionInvocation
  sns-iam_sfn_attach_policy_publish_sns-name = var.sns-iam_sfn_attach_policy_publish_sns-name
  source-file-path                           = <path of Lamda code for AMI>
  source-file-path-ec2                       = <path of Lambda code for EC2 Launch>
}
```

### Variables

- **environment-name**

  Environment to create the table in (dev, qa, tcc, prod)

- **standard-tags**

  Base resource tags

- **step-function-name**

  The name of the step function

- **lambda-policy-name**
 
  Name of the polict attach to step function