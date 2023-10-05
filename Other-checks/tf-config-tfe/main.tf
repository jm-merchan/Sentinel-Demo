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
  name         = var.project
  organization = var.organization
}

resource "tfe_workspace" "sentinel_test_workspace" {
  name                          = var.workspace
  organization                  = var.organization
  auto_apply                    = true
  allow_destroy_plan            = true
  queue_all_runs                = false
  speculative_enabled           = true
  structured_run_output_enabled = true

  execution_mode      = "remote"
  assessments_enabled = true
  global_remote_state = false
  project_id          = tfe_project.sentinel_test_project.id
  # terraform_version     = "1.4.0"
  working_directory     = var.working_dir
  file_triggers_enabled = true
  vcs_repo {
    branch             = ""
    ingress_submodules = false
    identifier         = var.repo
    oauth_token_id     = var.gh_token
  }
}


resource "tfe_variable" "cidr" {
  key          = "range"
  value        = jsonencode(var.cidrs)
  category     = "terraform"
  workspace_id = tfe_workspace.sentinel_test_workspace.id
  description  = "List of CIDRs allow to access on port 22/SSH"
  hcl          = true
}

resource "tfe_variable" "public_key" {
  key          = "public_key"
  value        = var.public_key
  category     = "terraform"
  workspace_id = tfe_workspace.sentinel_test_workspace.id
  description  = "SSH Public key"
  sensitive    = true
}

/*
resource "tfe_workspace_run" "ws_run_sentinel_test_workspace" {
  workspace_id = tfe_workspace.sentinel_test_workspace.id

  apply {
    manual_confirm = false
    retry          = false
  }

  destroy {
    manual_confirm = false
    retry          = false
    wait_for_run   = true
  }
}
*/


# Steps to upload folder with Sentinel configuration

data "tfe_slug" "test" {
  // point to the local directory where the policies are located.
  source_path = "../policy-set"
}

resource "tfe_policy_set" "test" {
  name         = "aws-ec2-instance-sg"
  description  = "Control instance type and Security Group"
  organization = var.organization
  # global       = true
  workspace_ids = [tfe_workspace.sentinel_test_workspace.id]

  // reference the tfe_slug data source.
  slug = data.tfe_slug.test
}

