data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

#
# When there is an existing lambda function, we can use this to get the image URI
#
data "external" "lambda_properties_code" {
  program = [
    "sh", 
    "-c", 
    <<-EOF
      set -e
      RESULT=$(aws lambda get-function --function-name ${module.this.id} --query 'Code' --output json) || RESULT="{\"Code\": \"null\"}"
      echo "$RESULT"
    EOF
  ]
  depends_on = [ module.this ]
}