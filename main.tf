terraform {
  required_providers {
    rt = {
      source  = "registry-tools/rt"
      version = "0.1.0-dev1"
    }
  }
}

# Your registry namespace. This becomes part of the module path
resource "rt_namespace" "this" {
  name        = var.namespace
  description = "Modules provided by the platform team"
}

# A token that can be used to provision modules
# from the namespace
resource "rt_terraform_token" "provisioner" {
  namespace_id = rt_namespace.this.id
  role         = "provisioner"
  expires_in   = "never"
}

# A connection to a VCS provider that can be used to automate
# module publishing
resource "rt_vcs_connector" "github" {
  count = contains([for item in var.vcs_tag_publishers : item.provider], "github") ? 1 : 0
  github = {
    token = var.github_token
  }
}

resource "rt_tag_publisher" "tag_publishers" {
  for_each = { for item in var.vcs_tag_publishers : item.repo_identifier => item }

  vcs_connector_id = each.value.provider == "github" ? rt_vcs_connector.github[0].id : null
  namespace_id     = rt_namespace.this.id
  repo_identifier  = each.key
  backfill_pattern  = lookup(each.value, "backfill_pattern", null)
}

output "terraform_token" {
  value     = rt_terraform_token.provisioner.token
  sensitive = true
}
