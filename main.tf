# -----------------------------------------------------------------------------
# ECR
# -----------------------------------------------------------------------------
variable "ecr_max_image_count" {
  type    = number
  default = 10
}

variable "ecr_protected_tags" {
  type    = list(string)
  default = ["main"]
}

variable "ecr_image_tag_mutability" {
  type    = string
  default = "MUTABLE"
}


module "ecr" {
  source  = "cloudposse/ecr/aws"
  version = "v0.41.0"

  context              = module.this.context
  image_tag_mutability = var.ecr_image_tag_mutability
  max_image_count      = var.ecr_max_image_count
  protected_tags       = var.ecr_protected_tags
}

# -----------------------------------------------------------------------------
# Lambda
# -----------------------------------------------------------------------------

variable "lambda_architecture" {
  type        = string
  default     = "x86_64"
  description = "The architecture of the lambda function: possible values are 'x86_64' and 'arm64'"
}

variable "lambda_memory_size" {
  type        = number
  default     = 128
  description = "The memory size of the lambda function in megabytes, default is 128"
}

variable "lambda_timeout" {
  type        = number
  default     = 30
  description = "The timeout of the lambda function in seconds, default is 30"
}

variable "lambda_cloudwatch_logs_retention_in_days" {
  type        = number
  default     = 7
  description = "The retention period of the cloudwatch logs in days, default is 7"
}

module "lambda" {
  source  = "cloudposse/lambda-function/aws"
  context = module.this.context

  function_name                     = module.this.id
  image_uri                         = module.ecr.repository_url
  package_type                      = "Image"
  architectures                     = [var.lambda_architecture]
  cloudwatch_logs_retention_in_days = var.lambda_cloudwatch_logs_retention_in_days
  ssm_parameter_names               = []
  timeout                           = var.lambda_timeout
  memory_size                       = var.lambda_memory_size

  # todo: add default lambda_environment variables
  # lambda_environment = {
  #   "variables" = {
  #     "PLATFORM"     = "aws_lambda",
  #     "LOGURU_LEVEL" = "INFO"
  #   }
  # }

  # todo: add image_config
  # image_config = {
  #   command = ["python", "my_script.py"]
  #   entry_point = []
  # }

  # v2 feature
  # vpc_config = {
  #   subnet_ids         = module.vpc.private_subnet_ids
  #   security_group_ids = [module.sg_lambda_prtmgt.id]
  # }
}
