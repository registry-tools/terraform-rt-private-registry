terraform {
  required_providers {
    rt = {
      source  = "registry-tools/rt"
      version = "1.0.0"
    }
  }
}

provider "rt" {
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
  count = contains(values(var.vcs_tag_publishers), "github") ? 1 : 0
  github = {
    token = var.github_token
  }
}

resource "rt_tag_publisher" "tag_publishers" {
  for_each = var.vcs_tag_publishers

  vcs_connector_id = each.value == "github" ? rt_vcs_connector.github[0].id : null
  namespace_id     = rt_namespace.this.id
  repo_identifier  = each.key
}

output "terraform_token" {
  value     = rt_terraform_token.provisioner.token
  sensitive = true
}
