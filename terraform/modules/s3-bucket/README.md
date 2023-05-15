
## S3-Storage - Terraform Module

### Description
This Terraform project will provision the necessary S3 Storage for state file.


### Usage:

To set up the defined Storage module Resources:

``` terraform
module "s3-bucket" {
  source                 = "../../modules/s3-bucket"
  environment-name       = <dev|qa|tcc|prod>
  standard-tags          = < Base resource tags >
  bucket-name            = "co-uk-non-prod-dev-terraform"
  enable-encryption      = false
  enable-public          = true
  expiration-days        = 365
  bucket-policy          = {
    enabled = true
    policy  = <<POLICY
{
    json policy
}
POLICY
  }
}
```

### Variables

- **environment-name**

  Environment to create the table in (dev, qa, tcc, prod)

- **standard-tags**

  Base resource tags

- **bucket-name**

  The name of the s3 bucket

- **enable-encryption**

  Enables server side encryption for the s3 bucket

- **enable-public**

  Toggle if Block all public access should be enabled for the s3 bucket

- **expiration-days**

  Number of days to keep objects for the s3 bucket

- **bucket-policy**

  Pass in an s3 bucket policy