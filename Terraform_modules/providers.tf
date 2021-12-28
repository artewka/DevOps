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
   access_key = "AKIAZJUOCNDEJLKVZPER"
   secret_key = "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"
   region     = "eu-central-1"
}


provider "cloudflare" {
   email = "shadak1997@gmail.com"
   api_key = "cce4a5bb0b1db178ca20808e43a3ef130dcd5"
   version = "~> 3.0"
}