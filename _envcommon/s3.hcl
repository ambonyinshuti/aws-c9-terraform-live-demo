locals {
  def = merge(
    yamldecode(
      file(find_in_parent_folders("env.yaml", "{}")),
    ),
    yamldecode(
      file(find_in_parent_folders("regional.yaml", "{}")),
    ),
    yamldecode(
      file(find_in_parent_folders("_envcommon/s3-buckets.yaml", "{}")),
    )
  )

  env  = local.def.env
  rgn  = local.def.rgn
  convention-naming = "c9-${local.env}-${local.rgn}"
  buckets = try({ for s3b in "${local.def.s3commonbuckets}": "${local.convention-naming}-${s3b}" => { bucket = "${local.convention-naming}-${s3b}" } }, {})

  s3commonbuckets = "${local.buckets}"
}
