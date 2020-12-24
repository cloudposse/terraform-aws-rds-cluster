terraform {
  required_version = ">= 0.12.26"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.1.15"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 2.0"
    }
  }
}
