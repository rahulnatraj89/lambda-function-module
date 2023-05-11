resource "aws_lambda_function" "lambda" {
  function_name = ""
  filename = "lambda_function.zip"
  handler = "lambda_function"
  runtime = "python3.9"
  publish = true
  role = aws_iam_role.lambda.arn
}

resource "aws_lambda_function" "lambda-function" {
  function_name = ""
  filename = "lambda_function.zip"
  handler = "lambda_function"
  runtime = "python3.9"
  publish = true
  role = aws_iam_role.lambda.arn
}

resource "aws_lambda_event_source_mapping" "lambda_2" {
  event_source_arn = "arn:aws:sqs:${var.region}:${var.aws_account}:${var.name}"
  function_name    = aws_lambda_function..arn
}


resource "aws_lambda_function" "lambda_3" {
  function_name = ""
  filename = "lambda_function.zip"
  handler = "lambda_function"
  runtime = "python3.9"
  publish = true
  role = aws_iam_role.lambda.arn
}
resource "aws_lambda_event_source_mapping" "lambda_2" {
  event_source_arn = "arn:aws:sqs:${var.region}:${var.aws_account}:${var.name}"
  function_name    = aws_lambda_function.lambda_2.arn
}
resource "aws_iam_role_policy_attachment" "assume_role" {

 policy_arn = aws_iam_policy.sqs_lambda.arn
 role       = aws_iam_role.lambda.name
}

resource "aws_iam_policy" "sqs_lambda" {
  name   = ""
  policy = "${data.aws_iam_policy_document.this.json}"
}


resource "aws_iam_role" "lambda" {
name = ""

assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
