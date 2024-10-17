variable "namespace" {
  description = "Registry Namespace name. This name appears in module paths in your private registry."
  type        = string
}

variable "vcs_tag_publishers" {
  description = "GitHub repositories containing modules that you want to release automatically when a version tag is pushed."
  type        = set(object({ repo_identifier = string, provider = string, backfill_pattern = optional(string) }))
  default     = []
}

variable "github_token" {
  description = "GitHub token for tag publishing."
  type        = string
  sensitive   = true
  default     = ""
}
