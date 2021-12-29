terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 3.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


provider "aws" {
   access_key = ""
   secret_key = ""
   region     = "eu-central-1"
}


provider "cloudflare" {
   email = ""
   api_key = ""
   version = "~> 3.0"
}
