module "s3" {
  source  = "./modules/s3/v1.0.0"
  version = "1.0.1"

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
