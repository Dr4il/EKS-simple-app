provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "infra_bucket" {
  bucket = "infrastate-bucket"
  acl    = "private"
  tags = var.tags
}

terraform {
  backend "s3" {
    bucket = "infrastate-bucket"
    key    = "terraform/infra.tfstate"
    region = "eu-west-1"
  }
}

