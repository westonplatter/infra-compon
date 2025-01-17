terraform {
  required_version = ">= 1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.0"
    }
    external = {
      source  = "hashicorp/external"
      version = ">= 1.1"
    }
  }
}