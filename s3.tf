#------------------------------------
# S3bucket
#------------------------------------
resource "aws_s3_bucket" "dev" {
  bucket = "${var.environment}-${var.project}-oai-s3"
}
#ブロックパブリックアクセス
resource "aws_s3_bucket_public_access_block" "dev" {
  bucket                  = aws_s3_bucket.dev.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  depends_on = [
    aws_s3_bucket_policy.dev
  ]
}

#バケットポリシー
resource "aws_s3_bucket_policy" "dev" {
  bucket = aws_s3_bucket.dev.id
  policy = data.aws_iam_policy_document.s3_dev_policy.json
}

data "aws_iam_policy_document" "s3_dev_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.dev_identity.iam_arn]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.dev.arn}/*"]
  }
}
