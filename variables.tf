variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "github_username" {
  default = "tomas0i"
  type    = string
}

variable "atlantis_repo_allow_list" {
  default = "github.com/tomas0i/atlantis-demo"
  type    = string
}

variable "atlantis_secrets_name" {
  description = "as stored in the AWS Secrets Manager"
  type    = string
  default = "atlantis-demo/secrets"
}