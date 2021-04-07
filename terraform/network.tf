resource "aws_vpc" "cluster_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = var.tags
}

resource "aws_subnet" "subnet_a" {
  vpc_id     = aws_vpc.cluster_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone_id = "euw1-az1"
  tags = var.tags
}

resource "aws_subnet" "subnet_b" {
  vpc_id     = aws_vpc.cluster_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone_id = "euw1-az2"
  tags = var.tags
}

resource "aws_subnet" "subnet_c" {
  vpc_id     = aws_vpc.cluster_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone_id = "euw1-az3"
  tags = var.tags
}