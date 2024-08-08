locals {
  default_yaml_path = find_in_parent_folders("empty.yaml")
  def = merge(
    {
      enable_secrets = true
    },
    yamldecode(
      file(find_in_parent_folders("tier.yaml", local.default_yaml_path)),
    ),
    yamldecode(
      file(find_in_parent_folders("env.yaml", local.default_yaml_path)),
    ),
    yamldecode(
      file(find_in_parent_folders("regional.yaml", local.default_yaml_path)),
    ),
    yamldecode(
      file(find_in_parent_folders("_env/common.yaml", local.default_yaml_path)),
    ),
    yamldecode(
      file("${get_terragrunt_dir()}/deploy.yaml"),
    )
  )

  default_tags      = merge(local.def.default_tags, 
	{ "provider_account" : local.def.provider_account, 
	"Env" : local.def.env, "Environment" : local.def.env, 
	"Rgn": local.def.rgn , "Tier" : local.def.tier })

}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::${local.def.account_id}:role/Admin"
  }
  region = "${local.def.region}"
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
    encrypt        = true
    dynamodb_table = "my-lock-table"
    acl            = "bucket-owner-full-control"
    role_arn = "arn:aws:iam::305658029247:role/Admin"
  }
}



inputs = merge(
    yamldecode(
      file(find_in_parent_folders("tier.yaml", local.default_yaml_path)),
    ),
    yamldecode(
      file(find_in_parent_folders("env.yaml", local.default_yaml_path)),
    ),
    yamldecode(
      file(find_in_parent_folders("regional.yaml", local.default_yaml_path)),
    ),
    yamldecode(
      file(find_in_parent_folders("_env/common.yaml", local.default_yaml_path)),
    ),
    yamldecode(
      file("${get_terragrunt_dir()}/deploy.yaml"),
    )
  )


