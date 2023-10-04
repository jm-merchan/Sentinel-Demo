data "tfe_slug" "test" {
  // point to the local directory where the policies are located.
  source_path = "../policy-set"
}

resource "tfe_policy_set" "test" {
  name          = "aws-s3-policy-control"
  description   = "Tags and ACL controls"
  organization  = "josemerchan-training"
  global = true

  // reference the tfe_slug data source.
  slug = data.tfe_slug.test
}