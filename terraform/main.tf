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
  filename      = "../build/authorization.zip"
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



