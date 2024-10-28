# -----------------------------------------------------------------------------
# Lambda
# -----------------------------------------------------------------------------

variable "ecr_repository_url" {
  type = string
  description = "The URL of the ECR repository"
}

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

variable "docker_lambda_command" {
  type = list(string)
  description = "The command to run in the lambda function" 
}

variable "docker_lambda_entry_point" {
  type = list(string)
  description = "The entry point to run in the lambda function"
  default = []
}

variable "lambda_environment_variables" {
  type = map(string)
  description = "The environment variables to set in the lambda function"
  default = {
    "PLATFORM"     = "aws_lambda",
    "LOGURU_LEVEL" = "INFO"
  }
}

module "lambda" {
  source  = "cloudposse/lambda-function/aws"
  context = module.this.context

  function_name                     = module.this.id
  image_uri                         = var.ecr_repository_url
  package_type                      = "Image"
  architectures                     = [var.lambda_architecture]
  cloudwatch_logs_retention_in_days = var.lambda_cloudwatch_logs_retention_in_days
  ssm_parameter_names               = []
  timeout                           = var.lambda_timeout
  memory_size                       = var.lambda_memory_size
  image_config = {
    command = var.docker_lambda_command
    entry_point = var.docker_lambda_entry_point
  }

  lambda_environment = {
    "variables" = var.lambda_environment_variables
  }

  # v2 feature
  # vpc_config = {
  #   subnet_ids         = module.vpc.private_subnet_ids
  #   security_group_ids = [module.sg_lambda_prtmgt.id]
  # }
}
