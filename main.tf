provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "hsa_bucket_logs" {
  bucket = "hsa-bucket-23-logs"
  force_destroy = true
}

resource "aws_s3_bucket" "hsa_source_bucket" {
  bucket = "hsa-source-bucket-23"
  force_destroy = true
  object_lock_enabled = true
}

resource "aws_s3_bucket_logging" "hsa_logs" {
  bucket        = aws_s3_bucket.hsa_source_bucket.id
  target_bucket = aws_s3_bucket.hsa_bucket_logs.id
  target_prefix = "/"
}

resource "aws_s3_bucket_policy" "hsa_logs_policy" {
  bucket = aws_s3_bucket.hsa_bucket_logs.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Id": "S3-Console-Auto-Gen-Policy-1730107169285",
    "Statement": [
        {
            "Sid": "S3PolicyStmt-DO-NOT-MODIFY-1730107168594",
            "Effect": "Allow",
            "Principal": {
                "Service": "logging.s3.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::hsa-bucket-23-logs/*",
            "Condition": {
                "StringEquals": {
                    "aws:SourceAccount": "010928187298"
                }
            }
        },
        {
            "Sid": "S3ServerAccessLogsPolicy",
            "Effect": "Allow",
            "Principal": {
                "Service": "logging.s3.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::hsa-bucket-23-logs/*",
            "Condition": {
                "StringEquals": {
                    "aws:SourceAccount": "010928187298"
                },
                "ArnLike": {
                    "aws:SourceArn": "arn:aws:s3:::hsa-source-bucket-23"
                }
            }
        }
    ]
})
}