provider "aws" {
  region = "us-east-1"
}

variable "context" {
  type = any
}

variable "image_tag_mutability" {
  type = string
  default = "MUTABLE"
}

variable "max_image_count" {
  type = number
  default = 10
}

variable "protected_tags" {
  type = list(string)
  default = ["main"]
}

module "ecr" {
  enabled = true
  source  = "cloudposse/ecr/aws"
  version = "v0.41.0"

  context              = var.context
  name                 = var.context.name
  image_tag_mutability = var.image_tag_mutability
  max_image_count      = var.max_image_count
  protected_tags       = var.protected_tags
}

output "repository_url" {
  value = module.ecr.repository_url
}

output "repository_arn" {
  value = module.ecr.repository_arn
}
