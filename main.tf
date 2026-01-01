module "s3" {
  source = "./modules/s3/v1.0.0"

  buckets = [
    {
      name       = "aurora-data-vault-logs"
      encrypted  = true
      versioning = true
      public     = false
    },
    {
      name       = "cloudforge-artifacts-prod"
      encrypted  = true
      versioning = true
      public     = false
    },
    {
      name       = "nimbus-secure-backups-01"
      encrypted  = true
      versioning = true
      public     = false
    },
    {
      name       = "atlas-terraform-state-store"
      encrypted  = true
      versioning = true
      public     = false
    },
    {
      name       = "sentinel-audit-trail-bucket"
      encrypted  = true
      versioning = true
      public     = false
    }
  ]
}

module "kms" {
  source = "./modules/kms/v1.0.0"

  kms_keys = []
}

module "ec2" {
  source = "./modules/ec2/v1.0.0"

  security_group_id = var.security_group_id
  instances         = var.instances
  subnet_ids        = var.subnet_ids
}
