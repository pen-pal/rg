output "rag_api_endpoint" {
  description = "API Gateway endpoint URL for Prod stage for RAG function"
  value       = "${aws_apigatewayv2_api.rag_api.api_endpoint}/rag"
}

output "rag_function_arn" {
  description = "RAG Lambda Function ARN"
  value       = aws_lambda_function.rag_function.arn
}

output "rag_function_role_arn" {
  description = "Implicit IAM Role created for RAG function"
  value       = aws_iam_role.rag_lambda_role.arn
}

output "document_bucket_name" {
  description = "S3 bucket where LanceDB sources embeddings. Check this repository README for instructions on how to import your documents"
  value       = aws_s3_bucket.document_bucket.bucket
}
