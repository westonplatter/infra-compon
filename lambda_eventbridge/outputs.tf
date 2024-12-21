output "lambda_image_uri" {
  value = local.full_ecr_image_url
}

output "lambda_arn" {
  value = module.lambda.arn
}

output "lambda_function_name" {
  value = module.lambda.function_name
}

output "invoke_arn" {
  value = module.lambda.invoke_arn
}

output "role_arn" {
  value = module.lambda.role_arn
}
