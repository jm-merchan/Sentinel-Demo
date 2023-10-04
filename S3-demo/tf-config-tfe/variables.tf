variable "organization" {
  type        = string
  description = "Your TFC org"
}

variable "project" {
  type        = string
  description = "Project Name"
}

variable "gh_token" {
  type        = string
  description = "OAuth Token ID"
}

variable "repo" {
  type        = string
  description = "Repo Reference"
}