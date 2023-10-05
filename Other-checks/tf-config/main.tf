terraform {
  required_providers {
    aws = {
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "random_pet" "petname" {
  length    = 4
  separator = "-"
}


resource "aws_s3_bucket" "dev" {
  bucket        = "sentinel-ws-${random_pet.petname.id}"
  force_destroy = true

  tags = {
    environment = "dev",
    # department = "sales"  # Uncomment to pass policy
  }
}

resource "aws_s3_bucket_policy" "dev" {
  bucket = aws_s3_bucket.dev.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::sentinel-ws-${random_pet.petname.id}/*"
            ]
        }
    ]
}
EOF

depends_on = [
  aws_s3_bucket_public_access_block.dev,
  aws_s3_bucket_ownership_controls.dev,
]
}

resource "aws_s3_bucket_ownership_controls" "dev" {
  bucket = aws_s3_bucket.dev.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "dev" {
  bucket = aws_s3_bucket.dev.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}



resource "aws_s3_bucket_acl" "dev" {
  bucket = aws_s3_bucket.dev.id
  acl    = "public-read" # Comment and uncomment below
  # acl    = "private"

  depends_on = [
    aws_s3_bucket_public_access_block.dev,
    aws_s3_bucket_ownership_controls.dev,
  ]
}
