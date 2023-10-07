data "archive_file" "lambda_app_artifact" {
  output_path = "${path.module}/lambda_app.zip"
  type = "zip"
  source_dir = "${path.module}/app"   
}

resource "aws_lambda_function" "lambda_app" {
  function_name = "lambda_app"
  role = aws_iam_role.lambda_app.arn
  runtime = "nodejs14.x"
  handler = "index.handler"
  filename = "lambda_app.zip"
  lifecycle {
    ignore_changes = [filename]
  }
}