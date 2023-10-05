variable "organization" {
  type        = string
  description = "Your TFC org"
}

variable "project" {
  type        = string
  description = "Project Name"
}

variable "workspace" {
  type        = string
  description = "workspace name"
}

variable "gh_token" {
  type        = string
  description = "OAuth Token ID"
}

variable "repo" {
  type        = string
  description = "Repo Reference"
}

variable "working_dir" {
  type        = string
  description = "Working Directory"
  default     = ""
}

variable "cidrs" {
  type        = list(string)
  description = "CIDR Ranges"
  default     = ["0.0.0.0/0"]
}

variable "public_key" {
  type        = string
  description = "Public Key for EC2 instance"
  sensitive   = true
}