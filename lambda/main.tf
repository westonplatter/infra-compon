# -----------------------------------------------------------------------------
# Lambda
# -----------------------------------------------------------------------------

locals {
  full_ecr_image_url = try(
    data.external.lambda_properties_code.result.ImageUri,
    "${var.ecr_repository}:${var.first_deploy_ecr_image_tag}"
  )
}


module "lambda" {
  source  = "cloudposse/lambda-function/aws"
  version = "v0.6.1"
  context = module.this.context

  function_name                     = module.this.id
  image_uri                         = local.full_ecr_image_url
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