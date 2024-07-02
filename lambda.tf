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

  inline_policy {
    name = "rag_policy"
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
            "s3:GetObject"
          ]
          Resource = "arn:aws:s3:::${aws_s3_bucket.document_bucket.bucket}/*"
        },
        {
          Effect = "Allow"
          Action = [
            "s3:ListBucket"
          ]
          Resource = "arn:aws:s3:::${aws_s3_bucket.document_bucket.bucket}"
        },
        {
          Effect = "Allow"
          Action = [
            "s3:ListAllMyBuckets"
          ]
          Resource = "*"
        },
        {
          Effect = "Allow"
          Action = [
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability"
          ]
          Resource = "*"
        },
        {
          Effect = "Allow"
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Resource = "*"
        }
      ]
    })
  }
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
