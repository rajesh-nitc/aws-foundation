terraform {
  backend "s3" {
    bucket = "bkt-tfstate-moved-anchovy"
    key    = "terraform/state/org"
    region = "us-east-1"
  }
}