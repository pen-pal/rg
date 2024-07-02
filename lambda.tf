resource "aws_iam_role" "rag_lambda_role" {
  name = "rag_lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_lambda_basic_execution_role" {
  role       = aws_iam_role.rag_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "rag_policy" {
  name = "rag_policy"
  role = aws_iam_role.rag_lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "bedrock:InvokeModel"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.document_bucket.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.document_bucket.bucket}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_lambda_function" "rag_function" {
  function_name = "rag_function"
  role          = aws_iam_role.rag_lambda_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.rag_repository.repository_url}:latest"
  memory_size   = 4048
  architectures = ["x86_64"]
  environment {
    variables = {
      s3BucketName = aws_s3_bucket.document_bucket.bucket
    }
  }
}
