terraform {
  backend "s3" {
    bucket = "bkt-tfstate-moved-anchovy"
    key    = "terraform/state/environments/development"
    region = "us-east-1"
  }
}