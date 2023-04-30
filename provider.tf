terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.2.1"
    }
  }

  backend "s3" {
    bucket = "jpterraformstate"
    key    = "private"
    region = "us-east-1"
  }
}
