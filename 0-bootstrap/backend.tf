terraform {
  backend "s3" {
    bucket = "bkt-tfstate-moved-anchovy"
    key    = "terraform/state/bootstrap"
    region = "us-east-1"
  }
}