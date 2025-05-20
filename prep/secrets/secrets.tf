#Provision secret values for the deployment

provider "aws" {
  region = "eu-central-1"
}

resource "random_password" "atlantis_gh_secret" {
  length           = 36
  special          = true
  override_special = "()_[]{}<>"
}


resource "aws_secretsmanager_secret" "atlantis_secrets" {
  name                    = "atlantis-demo/secrets"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "atlantis_secrets_version" {
  secret_id = aws_secretsmanager_secret.atlantis_secrets.id
  secret_string = jsonencode(
    {

      atlantis_secret = random_password.atlantis_gh_secret.result
      github_token = "<YOUR_GthubToken_HERE>"
      atlantis_aws_credentials = "[default] \n aws_access_key_id = <YOUR_AtantisAwsAccessKeyId_HERE> \n aws_secret_access_key = <YOUR_AwsAccessKey_HERE> \n region=eu-central-1"

    }
  )
}

