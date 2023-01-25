resource "aws_s3_bucket" "bucket" {
    bucket = var.bucket_name
    lifecycle {
      prevent_destroy = false
    }
  
}
resource "aws_s3_bucket_versioning" "s3_ver" {
    bucket = aws_s3_bucket.bucket.id
    versioning_configuration {
      status = "Enabled"
    }
  
}

resource "aws_dynamodb_table" "dy_db" {
    name = var.dynamo_name
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"
    attribute {
      name = "LockID"
      type = "S"
    }
  
}