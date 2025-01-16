variable "first_deploy_ecr_image_tag" {
  type        = string
  description = "The initial image tag to use for the first deployment of the Lambda function"
  default     = "latest"
}

variable "ecr_repository" {
  type = string
  description = "The URL of the ECR repository. For example: 123456789012.dkr.ecr.us-east-1.amazonaws.com/{namespace}-{stage}-{name}"
}

variable "lambda_architecture" {
  type        = string
  default     = "x86_64"
  description = "The architecture of the lambda function: possible values are 'x86_64' and 'arm64'"

  validation {
    condition     = contains(["x86_64", "arm64"], var.lambda_architecture)
    error_message = "Invalid architecture specified. Possible values are 'x86_64' and 'arm64'."
  }
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

variable "ssm_parameter_names" {
  description = "List of SSM Parameter Store parameter names to grant access to"
  type        = list(string)
  default     = []
}