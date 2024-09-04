terraform {
  #source = "tfr:///terraform-aws-modules/s3-bucket/aws//wrappers"
  # Alternative source:
  #source = "git::git@github.com:terraform-aws-modules/terraform-aws-s3-bucket.git//wrappers?ref=master"
  #source = "git::git@github.com:terraform-aws-modules/terraform-aws-s3-bucket.git//wrappers?ref=v4.1.2"
  source = "git::git@github.com:SymphonyOSF/aws-sre-terraform-modules.git//s3-bucket/wrappers?ref=s3-bucket-v4.1.2"
}


