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
      name       = "poc-unencrypted-public-1"
      encrypted  = false
      versioning = false
      public     = true
    },
    {
      name       = "poc-no-versioning-2"
      encrypted  = true
      versioning = false
      public     = false
    },
    {
      name       = "poc-public-access-3"
      encrypted  = true
      versioning = true
      public     = true
    },
    {
      name       = "poc-compliant-4"
      encrypted  = true
      versioning = true
      public     = false
    },
    {
      name       = "poc-compliant-5"
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
      alias           = "poc-kms-no-rotation-1"
      enable_rotation = false
      key_description = "Key rotation disabled"
    },
    {
      alias           = "poc-kms-rotation-2"
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
      name          = "poc-ec2-idle-dev-1"
      instance_type = "t3.micro"
      environment   = "dev"
    },
    {
      name          = "poc-ec2-idle-prod-2"
      instance_type = "t3.micro"
      environment   = "prod"
    },
    {
      name          = "poc-ec2-active-3"
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