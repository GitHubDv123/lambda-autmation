data "aws_region" "current" {}
# Create IAM role for AWS Step Function
resource "aws_iam_role" "iam_for_sfn" {
  name = "${var.sfn-role-name}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "states.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  tags               = merge(var.standard-tags, tomap({ "Name" = "${var.sfn-role-name}-role" }))
}


resource "aws_iam_policy" "policy_publish_sns" {
  name = "${var.sns-policy-name}-policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
              "sns:Publish",
              "sns:SetSMSAttributes",
              "sns:GetSMSAttributes"
            ],
            "Resource": "*"
        }
    ]
}
EOF
  tags   = merge(var.standard-tags, tomap({ "Name" = "${var.sns-iam_sfn_attach_policy_publish_sns-name}-policy" }))
}


resource "aws_iam_policy" "policy_invoke_lambda" {
  name = "${var.lambda-policy-name}-policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction",
                "lambda:InvokeAsync"
            ],
            "Resource": "*"
        }
    ]
}
EOF
  tags   = merge(var.standard-tags, tomap({ "Name" = "${var.lambda-policy-name}-policy" }))
}


// Attach policy to IAM Role for Step Function
resource "aws_iam_role_policy_attachment" "iam_for_sfn_attach_policy_invoke_lambda" {
  role       = aws_iam_role.iam_for_sfn.name
  policy_arn = aws_iam_policy.policy_invoke_lambda.arn
}

resource "aws_iam_role_policy_attachment" "iam_for_sfn_attach_policy_publish_sns" {
  role       = aws_iam_role.iam_for_sfn.name
  policy_arn = aws_iam_policy.policy_publish_sns.arn
}



// Create state machine for step function
resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = var.step-function-name
  role_arn = aws_iam_role.iam_for_sfn.arn

  definition = <<EOF

{
  "Comment": "EC2 launch from hardend AMI",
  "StartAt": "ami-backup-state",
  "States": {
    "ami-backup-state": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "OutputPath": "$.Payload",
      "Parameters": {
        "FunctionName": "$.ami_lambda_function_arn"
      },
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException",
            "Lambda.TooManyRequestsException"
          ],
          "IntervalSeconds": 2,
          "MaxAttempts": 2,
          "BackoffRate": 2
        }
      ],
      "Next": "ec2-creation-state"
    },
    "ec2-creation-state": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "OutputPath": "$.Payload",
      "Parameters": {
        "Payload.$": "$",
        "FunctionName": "$.launch_lambda_function_arn"
      },
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException",
            "Lambda.TooManyRequestsException",
            "States.Timeout",
            "Lambda.Unknown"
          ],
          "IntervalSeconds": 2,
          "MaxAttempts": 2,
          "BackoffRate": 2
        }
      ],
      "End": true
    }
  }
}
EOF

  depends_on = [aws_lambda_function.Launch-EC2-Instances-lambda, aws_lambda_function.Launch-EC2-Instances-lambda]
  tags       = merge(var.standard-tags, tomap({ "Name" = "${var.step-function-name}" }))

}