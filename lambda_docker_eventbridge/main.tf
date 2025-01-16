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
  timeout                           = var.lambda_timeout
  memory_size                       = var.lambda_memory_size
  image_config = {
    command = var.docker_lambda_command
    entry_point = var.docker_lambda_entry_point
  }

  lambda_environment = {
    "variables" = var.lambda_environment_variables
  }

  custom_iam_policy_arns = var.custom_iam_policy_arns

  ssm_parameter_names               = var.ssm_parameter_names

  # v2 feature
  # vpc_config = {
  #   subnet_ids         = module.vpc.private_subnet_ids
  #   security_group_ids = [module.sg_lambda_prtmgt.id]
  # }
}

resource "aws_iam_role_policy" "ssm_access" {
  depends_on = [ module.lambda ]
  count = length(var.ssm_parameter_names) > 0 ? 1 : 0
  
  name = "${module.this.id}-ssm-access"
  role = module.lambda.role_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters"
        ]
        Resource = [
          for param_name in var.ssm_parameter_names :
          "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter${param_name}"
        ]
      }
    ]
  })
}


resource "aws_cloudwatch_event_rule" "schedules" {
  schedule_expression = each.value.schedule_expression
  event_bus_name      = "default"
  tags = module.this.tags
  
  for_each = var.aws_cloudwatch_event_triggers
  name                = "${module.this.id}-${each.key}"
  description         = "Schedule for Lambda Function - ${each.key}"
}

resource "aws_cloudwatch_event_target" "schedule_lambda" {
  target_id = "processing_lambda"
  arn       = module.lambda.arn

  for_each = var.aws_cloudwatch_event_triggers
  rule      = aws_cloudwatch_event_rule.schedules[each.key].name
  input = each.value.input
}

resource "aws_lambda_permission" "allow_events_bridge_to_run_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.function_name
  principal     = "events.amazonaws.com"

  for_each = var.aws_cloudwatch_event_triggers
  statement_id  = "AllowExecutionFromCloudWatch-${each.key}"
  source_arn    = aws_cloudwatch_event_rule.schedules[each.key].arn
}
