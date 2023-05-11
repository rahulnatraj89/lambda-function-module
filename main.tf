variable "region" {
  default = "us-west-2"
}

variable "aws_account" {
  default = "123456789012"
}

resource "aws_iam_policy_document" "lambda" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda" {
  name = "lambda_policy"
  policy = aws_iam_policy_document.lambda.json
}

resource "aws_iam_role" "lambda" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda" {
  policy_arn = aws_iam_policy.lambda.arn
  role       = aws_iam_role.lambda.name
}

resource "aws_lambda_function" "lambda" {
  count = 10

  function_name = "lambda_${count.index}"
  filename = "lambda_function.zip"
  handler = "lambda_function"
  runtime = "python3.9"
  publish = true
  role = aws_iam_role.lambda.arn
}

resource "aws_lambda_event_source_mapping" "lambda" {
  count = 10

  event_source_arn = "arn:aws:${var.region}:${var.aws_account}:sqs:my-queue"
  function_name    = aws_lambda_function.lambda[count.index].arn
}
