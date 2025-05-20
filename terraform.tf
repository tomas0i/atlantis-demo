terraform {

  backend "s3" {
    bucket         = "tf-state-for-atlantis-demo-2025-05"
    key            = "atlantis-demo/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
    #lock_table     = "terraform-locks"
  }


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.98.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.36.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.7"
    }
  }

  required_version = "~> 1.3"

}
