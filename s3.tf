resource "aws_s3_bucket" "document_bucket" {
  bucket = "${var.stack_name}-document-bucket"
}

resource "aws_s3_bucket_policy" "document_bucket_policy" {
  bucket = aws_s3_bucket.document_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = ":"
        }
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.document_bucket.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.document_bucket.bucket}/*"
        ]
      }
    ]
  })
}
