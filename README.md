# AWS C9 Terraform Live


## Prerequisites 

### Downloads and install the tools below : 

- Terragrunt  version >= v0.64.4
- Terraform version >= 1.9.x 

### Add new S3 bucket

```bash

#1. Clone the repository

#2. Add a new bucket in the env and region you want (i.e dev4/use1)

#3. Add the line below in items block in this file dev4/use1/s3/terragrunt.hcl

    bucket3 = {
      bucket = "c9-${include.root.locals.env}-${include.root.locals.rgn}-demo1"
    }

#4. Authenticate with aws-login script with jenkins role

#5. Deploy 

cd dev/dev4/use1/s3 

terragrunt plan 

terragrunt apply 


```

