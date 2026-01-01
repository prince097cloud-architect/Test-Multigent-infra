variable "buckets" {
  type = list(object({
    name       = string
    encrypted  = bool
    versioning = bool
    public     = bool
  }))
}

resource "aws_s3_bucket" "this" {
  for_each = { for b in var.buckets : b.name => b }

  bucket = each.key
}

resource "aws_s3_bucket_server_side_encryption_configuration" "enc" {
  for_each = { for b in var.buckets : b.name => b if b.encrypted }

  bucket = aws_s3_bucket.this[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  for_each = { for b in var.buckets : b.name => b if b.versioning }

  bucket = aws_s3_bucket.this[each.key].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "public" {
  for_each = { for b in var.buckets : b.name => b }

  bucket = aws_s3_bucket.this[each.key].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "bucket_names" {
  value = keys(aws_s3_bucket.this)
}
