terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_api_gateway_rest_api" "link-api" {
  name = "link-api"
}

resource "aws_api_gateway_resource" "authorize" {
  parent_id   = aws_api_gateway_rest_api.link-api.root_resource_id
  path_part   = "authorize"
  rest_api_id = aws_api_gateway_rest_api.link-api.id
}

resource "aws_api_gateway_method" "authorize-get" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.authorize.id
  rest_api_id   = aws_api_gateway_rest_api.link-api.id
}

resource "aws_api_gateway_method" "authorize-post" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.authorize.id
  rest_api_id   = aws_api_gateway_rest_api.link-api.id
}

resource "aws_api_gateway_integration" "authorize-get-integration" {
  rest_api_id             = aws_api_gateway_rest_api.link-api.id
  resource_id             = aws_api_gateway_resource.authorize.id
  http_method             = aws_api_gateway_method.authorize-get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.authorize.invoke_arn
}

resource "aws_api_gateway_integration" "authorize-post-integration" {
  rest_api_id             = aws_api_gateway_rest_api.link-api.id
  resource_id             = aws_api_gateway_resource.authorize.id
  http_method             = aws_api_gateway_method.authorize-post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.login.invoke_arn
}

resource "aws_api_gateway_resource" "token" {
  parent_id   = aws_api_gateway_rest_api.link-api.root_resource_id
  path_part   = "token"
  rest_api_id = aws_api_gateway_rest_api.link-api.id
}

resource "aws_api_gateway_method" "token" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.token.id
  rest_api_id   = aws_api_gateway_rest_api.link-api.id
}

resource "aws_api_gateway_integration" "token-integration" {
  rest_api_id             = aws_api_gateway_rest_api.link-api.id
  resource_id             = aws_api_gateway_resource.token.id
  http_method             = aws_api_gateway_method.token.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.token.invoke_arn
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_lambda_function" "authorize" {
  filename      = "../build/authorize.zip"
  function_name = "authorize"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_handler.handler"
  runtime = "python3.9"
}

resource "aws_lambda_function" "token" {
  filename      = "../build/token.zip"
  function_name = "token"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_handler.handler"
  runtime = "python3.9"
}

resource "aws_lambda_function" "login" {
  filename      = "../build/login.zip"
  function_name = "login"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_handler.handler"
  runtime = "python3.9"
}



