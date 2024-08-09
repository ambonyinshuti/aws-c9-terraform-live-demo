include "root" {
  path = find_in_parent_folders()
  expose = true
}

include "s3" {
  path = find_in_parent_folders("modules/s3.hcl")
  expose = true
}

include "s3" {
  path = "${dirname(find_in_parent_folders())}/_env/s3.hcl"
  expose = true
}

inputs = {
  defaults = {
    force_destroy                         = true
    attach_elb_log_delivery_policy        = false
    attach_lb_log_delivery_policy         = false
    attach_deny_insecure_transport_policy = true
    attach_require_latest_tls_policy      = true
    tags = "${include.root.locals.default_tags}" 
  }

  items = merge({
    bucket1 = {
      bucket = "c9-${include.root.locals.env}-${include.root.locals.rgn}-testterragrunt1"
    }
    bucket2 = {
      bucket = "c9-${include.root.locals.env}-${include.root.locals.rgn}-testterragrunt3"
      tags = merge("${include.root.locals.default_tags}", { Secure = "probably" })
    }

   }, "${include.s3.locals.s3}")
}

