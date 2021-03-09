# Static Site Terraform Module

Spin up a static website complete with SSL and CDN. Meant for quick simple websites, nothing too fancy.
Will spin up a logs bucket and a s3 origin user.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | >= 2.49 |

## Getting Started

Populate the variables.tf file in the root dir with your desired settings.

# Running
```bash
$ terraform init
$ terraform plan
$ terraform apply
```

# Additional Modules
## Modules

| Name | Source | Version |
|------|--------|---------|
| r53 | terraform-aws-route53 |  |



## Outputs 
| Name | Description |
|------|-------------|
| zone_id | Zone ID of Route53 zone |
| name_servers | Name Servers of Route53 zone |
| cloudfront_hostname | cloudfront hostname which has deployed your site|

### Tests and linting
Setup linting environment on mac with 
```make mac-lint```
Initiate linting with
```make lint```

### Versioning
I use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 
