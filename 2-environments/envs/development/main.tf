module "development" {
  source                = "../../modules/env_baseline"
  env                   = "development"
  network_account_email = "budita.org.d.network@gmail.com"
  org_group_name        = var.org_group_name
}