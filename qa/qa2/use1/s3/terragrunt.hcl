include "root" {
  path = find_in_parent_folders()
  expose = true
}

locals {
    buckets = try({ for s3b in "${include.root.locals.def.s3buckets}": "${include.root.locals.convention-naming}-${s3b}" => { bucket = "${include.root.locals.convention-naming}-${s3b}" } }, {})
}

include "s3" {
  path = find_in_parent_folders("modules/s3.hcl")
  expose = true
}

include "s3" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/s3.hcl"
  expose = true
}

inputs = {
  defaults = {
    force_destroy                         = true
    attach_elb_log_delivery_policy        = false
    attach_lb_log_delivery_policy         = false
    attach_deny_insecure_transport_policy = true
    attach_require_latest_tls_policy      = true
    versioning = { enabled = true }
    tags       = "${include.root.locals.default_tags}" 
  }

  items = merge("${include.s3.locals.s3commonbuckets}", "${local.buckets}")
}

