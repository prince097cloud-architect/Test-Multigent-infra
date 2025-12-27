variable "security_group_id" {
  type = string
}
// ...existing code...

variable "instances" {
  type = list(object({
    name          = string
    instance_type = string
    environment   = string
  }))
}

variable "subnet_ids" {
  type = list(string)
}

resource "aws_instance" "this" {
  for_each = { for idx, inst in var.instances : idx => inst }

  ami                    = "ami-00ca570c1b6d79f36" # Example AMI, replace as needed
  instance_type          = each.value.instance_type
  subnet_id              = var.subnet_ids[each.key % length(var.subnet_ids)]
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name        = each.value.name
    Environment = each.value.environment
  }
}

// ...existing code...

output "instance_ids" {
  value = { for k, v in aws_instance.this : k => v.id }
}
