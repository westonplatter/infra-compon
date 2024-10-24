variable "function_name" {
  type = string
  default = "MyFunctionName"
}

variable "image_uri" {
  type = string
  default = "MyImageUri"
}

module "lambda" {
  source  = "cloudposse/lambda-function/aws"
  # context = module.this.context
  # attributes = ["prtmgt"]

  function_name = var.function_name
  image_uri     = var.image_uri
  package_type  = "Image"
  lambda_environment = {
    "variables" = {
      "PLATFORM"     = "aws_lambda",
      "LOGURU_LEVEL" = "INFO"
    }
  }
  # architectures                     = ["arm64"]
  architectures                     = ["x86_64"]
  cloudwatch_logs_retention_in_days = 7
  ssm_parameter_names = []
  timeout = 30
  # vpc_config = {
  #   subnet_ids         = module.vpc.private_subnet_ids
  #   security_group_ids = [module.sg_lambda_prtmgt.id]
  # }
  memory_size = 128
  image_config = {
    command = ["python", "my_script.py"]
    entry_point = []
  }
}

