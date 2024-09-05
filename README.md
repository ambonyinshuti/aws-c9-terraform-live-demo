# AWS C9 Terraform Live


## Prerequisites 

### Downloads and install the tools below : 

- Terragrunt  version >= v0.64.4
- Terraform version >= 1.9.x 

### Add new S3 bucket

```bash

#1. Clone the repository

#2. Add a new common bucket for all tiers (i.e edit this file _envcommon/s3-buckets.yaml) 

#3. Add a new bucket dedicated to a region (i.e edit this file dev/dev4/use1/s3/deploy.yaml)

#4. Authenticate with aws-login script with jenkins role

#5. Deploy 

cd dev/dev4/use1/s3 

terragrunt plan 

terragrunt apply 


```

