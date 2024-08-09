locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("tier.hcl"))
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("regional.hcl"))
  common_vars = read_terragrunt_config(find_in_parent_folders("_env/common.hcl"))

  # Extract the variables we need for easy access
  account_id        = local.account_vars.locals.account_id
  tier              = local.account_vars.locals.tier
  provider_account  = local.account_vars.locals.provider_account
  env               = local.env_vars.locals.env
  environment       = local.env_vars.locals.environment
  region            = local.region_vars.locals.region
  rgn               = local.region_vars.locals.rgn
  default_tags      = merge(local.common_vars.locals.default_tags, 
	{ "provider_account" : local.account_vars.locals.provider_account, 
	"Env" : local.env_vars.locals.env, "Environment" : local.env_vars.locals.env, 
	"Rgn": local.region_vars.locals.rgn , "Tier" : local.account_vars.locals.tier })

 # s3 = {
 #   bucket-common-1 = {
 #     bucket = "c9-${local.env}-${local.rgn}-failer-ar-terragrunt1"
 #   }
 # }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  #source = "hashicorp/aws" 
  #version = "5.40.0"
  assume_role {
    role_arn = "arn:aws:iam::${local.account_id}:role/Admin"
  }
  region = "${local.region}"
}
EOF
}


remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "c9-util-terragrunt"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = false
    dynamodb_table = "my-lock-table"
    acl            = "bucket-owner-full-control"
    role_arn = "arn:aws:iam::305658029247:role/Admin"
  }
}



inputs = merge(
  local.account_vars.locals,
  local.env_vars.locals,
  local.region_vars.locals,
  local.default_tags,
)

