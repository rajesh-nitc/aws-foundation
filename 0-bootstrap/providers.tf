provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::${var.management_account_id}:role/${var.terraform_org_role}"
  }

  default_tags {
    tags = {
      Environment = "Foundation"
      Stage       = "Bootstrap"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  assume_role {
    role_arn = "arn:aws:iam::397706924023:role/OrganizationAccountAccessRole"
  }

  alias = "seed_account"

  default_tags {
    tags = {
      Environment = "Foundation"
      Stage       = "Bootstrap"
    }
  }
}