terraform {
  required_version = ">= 1.6.0"

  cloud {
    organization = "TFE-PROD-GRADE-INFRA"

    workspaces {
      name = "agentic-remediation-sandbox"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.40"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

########################################
# MODULE DEFINITIONS (with versions)
########################################

module "s3" {
  source  = "./modules/s3"
  version = "1.0.0"   # intentionally old version

  buckets = [
    # Non-compliant bucket 1: No encryption, no versioning, public allowed
    {
      name       = "poc-unencrypted-public-1"
      encrypted  = false
      versioning = false
      public     = true
    },

    # Non-compliant bucket 2: No versioning
    {
      name       = "poc-no-versioning-2"
      encrypted  = true
      versioning = false
      public     = false
    },

    # Non-compliant bucket 3: public access
    {
      name       = "poc-public-access-3"
      encrypted  = true
      versioning = true
      public     = true
    },

    # Compliant bucket 4
    {
      name       = "poc-compliant-4"
      encrypted  = true
      versioning = true
      public     = false
    },

    # Compliant bucket 5
    {
      name       = "poc-compliant-5"
      encrypted  = true
      versioning = true
      public     = false
    }
  ]
}

module "kms" {
  source  = "./modules/kms"
  version = "1.1.0"  # intentionally old version

  kms_keys = [
    {
      alias               = "poc-kms-no-rotation-1"
      enable_rotation     = false      # violation
      key_description     = "KMS key without rotation"
    },
    {
      alias               = "poc-kms-rotation-2"
      enable_rotation     = true
      key_description     = "Compliant key"
    },
    {
      alias               = "poc-kms-no-rotation-3"
      enable_rotation     = false      # violation
      key_description     = "Non-rotating key"
    }
  ]
}

module "ec2" {
  source  = "./modules/ec2"
  version = "1.0.0"    # intentionally old version

  instances = [
    {
      name      = "poc-ec2-idle-dev-1"
      instance_type = "t3.micro"
      environment   = "dev"
    },
    {
      name      = "poc-ec2-idle-prod-2"
      instance_type = "t3.micro"
      environment   = "prod"
    },
    {
      name      = "poc-ec2-active-3"
      instance_type = "t3.micro"
      environment   = "dev"
    },
    {
      name      = "poc-ec2-idle-dev-4"
      instance_type = "t3.micro"
      environment   = "dev"
    },
    {
      name      = "poc-ec2-active-5"
      instance_type = "t3.micro"
      environment   = "prod"
    }
  ]
}

########################################
# OUTPUTS
########################################

output "s3_buckets" {
  value = module.s3.bucket_names
}

output "kms_keys" {
  value = module.kms.key_arns
}

output "ec2_instances" {
  value = module.ec2.instance_ids
}
