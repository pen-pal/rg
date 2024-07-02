resource "aws_s3_bucket" "document_bucket" {
  bucket = "${var.stack_name}-document-bucket"
}
