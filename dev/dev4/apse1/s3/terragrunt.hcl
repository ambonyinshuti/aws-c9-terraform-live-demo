include "root" {
  path = find_in_parent_folders()
  expose = true
}

include "s3" {
  path = find_in_parent_folders("modules/s3.hcl")
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

  
  items = {  
    bucket1 = {
      bucket = "c9-${include.root.locals.def.env}-${include.root.locals.def.rgn}-testterragrunt1-yaml"
    }
    bucket2 = {
      bucket = "c9-${include.root.locals.def.env}-${include.root.locals.def.rgn}-testterragrunt3-yaml"
      tags = merge("${include.root.locals.default_tags}", { Secure = "probably" })
    }
  }
}

