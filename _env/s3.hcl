locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("regional.hcl"))
  env               = local.env_vars.locals.env
  rgn               = local.region_vars.locals.rgn

  s3 = {
    bucket-common-1 = {
      bucket = "c9-${local.env}-${local.rgn}-failer-ar-terragrunt1"
    }
  }
}

