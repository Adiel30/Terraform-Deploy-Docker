terraform {
  backend "s3" {
    bucket = "terraform-state-app"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}

