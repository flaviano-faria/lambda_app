resource "aws_api_gateway_rest_api" "api" {
  name = "apigtwapp"
}

resource "aws_api_gateway_method" "root_path" {
  rest_api_id           = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_rest_api.api.root_resource_id
  http_method           = "POST"
  authorization         = "NONE"
  
}

resource "aws_api_gateway_integration" "root_path" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_rest_api.api.root_resource_id
  http_method             = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_app.invoke_arn
  integration_http_method = "POST"
}
