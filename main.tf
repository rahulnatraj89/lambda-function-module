resource "aws_lambda_function" "lambda" {
  function_name = "hc-hcli-CarrierinfoApi-dev-usac-org"
  filename = "lambda_function.zip"
  handler = "lambda_function"
  runtime = "python3.9"
  publish = true
  role = aws_iam_role.lambda.arn
}

resource "aws_lambda_function" "lambda-function" {
  function_name = "hc-hcli-CalculationsResultsWriter-dev-usac-org"
  filename = "lambda_function.zip"
  handler = "lambda_function"
  runtime = "python3.9"
  publish = true
  role = aws_iam_role.lambda.arn
}

resource "aws_lambda_event_source_mapping" "lambda_2" {
  event_source_arn = "arn:aws-us-gov:sqs:${var.region}:${var.aws_account}:hc-hcli-dev-calc-requests-queue-usac-org"
  function_name    = aws_lambda_function.calculationresultswriter.arn
}


resource "aws_lambda_function" "lambda_3" {
  function_name = "hc-hcli-HclCalculator-dev-usac-org"
  filename = "lambda_function.zip"
  handler = "lambda_function"
  runtime = "python3.9"
  publish = true
  role = aws_iam_role.lambda.arn
}
resource "aws_lambda_event_source_mapping" "lambda_2" {
  event_source_arn = "arn:aws-us-gov:sqs:${var.region}:${var.aws_account}:hc-hcli-dev-hcl-queue-usac-org"
  function_name    = aws_lambda_function.HclCalculator.arn
}
resource "aws_iam_role_policy_attachment" "assume_role" {

 policy_arn = aws_iam_policy.sqs_lambda.arn
 role       = aws_iam_role.lambda.name
}

resource "aws_iam_policy" "sqs_lambda" {
  name   = "hc-hcli-iam-lambda-policy"
  policy = "${data.aws_iam_policy_document.this.json}"
}


resource "aws_iam_role" "lambda" {
name = "hc-hcli-lambda-role"

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
