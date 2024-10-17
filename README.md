# `terraform-rt-private-registry` module

Creates a Terraform private registry and connects your GitHub modules to it using [Registry Tools](https://registry.tools)

## Usage

```hcl
module "private-registry-example" {
  source  = "registry-tools/private-registry"
  version = "0.1.0"

  # New Registry Tools Namespace name. This name appears
  # in module paths in your private registry.
  namespace = "platform"
  
  # Map of VCS repositories to VCS provider containing modules that you want
  # to release automatically (Only GitHub is supported right now)
  vcs_tag_publishers = [
    { provider = "github", repo_identifier = "your-org/terraform-aws-example-module" },
    { provider = "github", repo_identifier = "your-org/terraform-aws-another-example-module", backfill_pattern = "^v" },
  ]
  github_token = var.github_token
}

variable "github_token" {
  type      = string
  sensitive = true
}
```

## Inputs

| Name                    | Description                                                                                           | Type           | Default | Required |
|-------------------------|-------------------------------------------------------------------------------------------------------|----------------|---------|----------|
| `namespace`             | This name appears in module paths in your private registry.                                           | `string`       |         | yes      |
| `github_tag_publishers` | GitHub repositories containing modules that you want to release automatically                         | `set(object)` | `[]`    | no       |
| `github_token`          | A GitHub Personal Access Token or OAuth2 token that can manage webhooks on the specified repositories | `string`       | `""`    | no       |

## Outputs

| Name              | Sensitive | Description                                                                            |
|-------------------|-----------|----------------------------------------------------------------------------------------|
| `terraform_token` | yes       | A Registery Access token that terraform can use to install modules from this namespace |

## What Next?

After provisioning, push a tag to the specified repositories and start terraforming:

**1. Authenticate terraform to registrytools.cloud**

```
$ export TF_TOKEN_registrytools_cloud=$(terraform output -raw terraform_token)
```

**2. Terraform your module**

```hcl
module "my-module1" {
  source  = "registrytools.cloud/my-namespace/example-module/aws"
  version = "1.0.0"
}
```
