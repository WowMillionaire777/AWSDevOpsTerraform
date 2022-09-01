terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.18.0"
    }
  }

  backend "s3" {
    bucket = "tf-dev-state-123"
    key    = "dev_state"
    region = "us-east-1"
  }
}

