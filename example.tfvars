# See variables.tf for information
namespace          = "example"
vcs_tag_publishers = [
  { provider = "github", repo_identifier = "your-org/terraform-aws-example-module" },
  { provider = "github", repo_identifier = "your-org/terraform-aws-another-example-module", preload_pattern = "^v" },
]
