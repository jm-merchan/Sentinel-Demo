terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.48.0"
    }
  }
}

provider "tfe" {
  organization = var.organization
}


resource "tfe_project" "sentinel_test_project" {
  name         = "tfe_provider_workspaces"
  organization = var.organization
}

resource "tfe_workspace" "sentinel_test_workspace" {
  name                          = "Sentinel_Test2"
  organization                  = var.organization
  auto_apply                    = true
  allow_destroy_plan            = true
  queue_all_runs                = false
  speculative_enabled           = true
  structured_run_output_enabled = true

  execution_mode        = "remote"
  assessments_enabled   = true
  global_remote_state   = false
  project_id            = tfe_project.sentinel_test_project.id
  terraform_version     = "1.4.0"
  working_directory     = var.working_dir
  file_triggers_enabled = true
  vcs_repo {
    branch             = ""
    ingress_submodules = false
    identifier         = var.repo
    oauth_token_id     = var.gh_token
  }
}

resource "tfe_variable" "test" {
  key          = "range"
  value        = "${var.cidrs}"
  category     = "terraform"
  workspace_id = tfe_workspace.sentinel_test_workspace.id
  description  = "List of CIDRs allow to access on port 22/SSH"
}


# Steps to upload folder with Sentinel configuration
/*
data "tfe_slug" "test" {
  // point to the local directory where the policies are located.
  source_path = "../policy-set"
}

resource "tfe_policy_set" "test" {
  name         = "aws-s3-policy-control"
  description  = "Tags and ACL controls"
  organization = var.organization
  # global       = true
  workspace_ids = [tfe_workspace.sentinel_test_workspace.id]

  // reference the tfe_slug data source.
  slug = data.tfe_slug.test
}
*/
