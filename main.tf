terraform {
  backend "remote" {
    organization = "TFE-PROD-GRADE-INFRA"

    workspaces {
      name = "agentic-remediation-test-infra"
    }
  }
}


#############################################
# EXISTING NETWORK INPUTS
#############################################

variable "vpc_id" {
  default = "vpc-05172adce96edf32c"
}

variable "subnet_ids" {
  default = [
    "subnet-0347005957612f5c2",
    "subnet-0f838be41e48183a9"
  ]
}

#############################################
# SECURITY GROUP
#############################################

resource "aws_security_group" "poc_sg" {
  name        = "poc-remediation-sg"
  description = "SG for remediation POC"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#############################################
# S3 MODULE
#############################################

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
      name       = "cloudforge-artifacts-dev"
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

#############################################
# KMS MODULE
#############################################

module "kms" {
  source = "./modules/kms/v1.0.0"

  kms_keys = [
    {
      alias           = "poc-kms-1"
      enable_rotation = false
      key_description = "Key rotation disabled"
    },
    {
      alias           = "poc-kms-2"
      enable_rotation = true
      key_description = "Compliant key"
    }
  ]
}

#############################################
# EC2 MODULE
#############################################

module "ec2" {
  source = "./modules/ec2/v1.0.0"

  instances = [
    {
      name          = "poc-ec2-dev-1"
      instance_type = "t3.micro"
      environment   = "dev"
    },
    {
      name          = "poc-ec2-dev-2"
      instance_type = "t3.micro"
      environment   = "prod"
    },
    {
      name          = "poc-ec2-dev-3"
      instance_type = "t3.micro"
      environment   = "dev"
    }
  ]

  subnet_ids        = var.subnet_ids
  security_group_id = aws_security_group.poc_sg.id
}

#############################################
# OUTPUTS
#############################################

output "s3_buckets" {
  value = module.s3.bucket_names
}

output "kms_keys" {
  value = module.kms.key_arns
}

output "ec2_instances" {
  value = module.ec2.instance_ids
}