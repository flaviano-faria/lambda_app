    data "aws_iam_policy_document" "lambda_assume_role" {
      statement {
        actions = ["sts:AssumeRole"]
        principals {
          type = "Service"
          identifiers = ["lambda.amazonaws.com"]
        }
      }
    }

  resource "aws_iam_role" "lambda_app" {
    name = "lambda-api-lambda-role"
    assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json     
  }

  resource "aws_lambda_permission" "allow_apigtw" {
    statement_id  = "AllowExecutionFromApiGtw"
    action        = "lambda:InvokeFunction"
    function_name = "arn:aws:lambda:us-east-1:920957086702:function:lambda_app"
    principal     = "apigateway.amazonaws.com"    
    source_arn    = "arn:aws:execute-api:us-east-1:920957086702:${aws_api_gateway_rest_api.api.id}/test-invoke-stage/POST/"
  }


    data "aws_iam_policy_document" "create_logs_cloudwatch" {
      statement {
        sid = "AllowCreatingLogGroups"
        effect = "Allow"
        resources = ["arn:aws:logs:*:*:*"]
        actions = ["logs:CreateLogGroup"]
      }

      statement {
        sid = "AllowWritingLogs"
        effect = "Allow"
        resources = ["arn:aws:logs:*:*:log-group:/aws/lambda/*:*"]
         actions = [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]
      }
    }

    resource "aws_iam_policy" "create_logs_cloudwatch" {
      name = "create-cw-logs-policy"
      policy = data.aws_iam_policy_document.create_logs_cloudwatch.json
    }

    resource "aws_iam_role_policy_attachment" "lambda_app_cloudwatch" {
      policy_arn = aws_iam_policy.create_logs_cloudwatch.arn
      role = aws_iam_role.lambda_app.name
    }