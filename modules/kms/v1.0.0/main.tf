variable "kms_keys" {
  type = list(object({
    alias           = string
    enable_rotation = bool
    key_description = string
  }))
}

resource "aws_kms_key" "this" {
  for_each = { for k in var.kms_keys : k.alias => k }

  description         = each.value.key_description
  enable_key_rotation = each.value.enable_rotation
}

resource "aws_kms_alias" "alias" {
  for_each = aws_kms_key.this

  name          = "alias/${each.key}"
  target_key_id = each.value.key_id
}

output "key_arns" {
  value = { for k, v in aws_kms_key.this : k => v.arn }
}
