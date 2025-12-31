resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_config_poc_compliant_4" {
  bucket = "poc-compliant-4"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_config_poc_compliant_5" {
  bucket = "poc-compliant-5"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_config_poc_no_versioning_2" {
  bucket = "poc-no-versioning-2"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_config_poc_public_access_3" {
  bucket = "poc-public-access-3"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption_config_poc_unencrypted_public_1" {
  bucket = "poc-unencrypted-public-1"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block_poc_compliant_4" {
  bucket = "poc-compliant-4"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "public_access_block_poc_compliant_5" {
  bucket = "poc-compliant-5"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "public_access_block_poc_no_versioning_2" {
  bucket = "poc-no-versioning-2"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "public_access_block_poc_public_access_3" {
  bucket = "poc-public-access-3"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "public_access_block_poc_unencrypted_public_1" {
  bucket = "poc-unencrypted-public-1"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}