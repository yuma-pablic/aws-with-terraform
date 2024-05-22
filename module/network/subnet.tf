resource "aws_subnet" "private_container_1a" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.8.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.env}-${var.service}-subnet-private-container-1a"
    Type = "Isolated"
  }
}


resource "aws_subnet" "private_container_1c" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.9.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.env}-${var.service}-subnet-private-container-1c"
    Type = "Isolated"
  }
}


resource "aws_subnet" "public_ingress_1a" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-${var.service}-subnet-public-ingress-1a"
    Type = "public"
  }
}

resource "aws_subnet" "public_ingress_1c" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-${var.service}-subnet-public-ingress-1c"
    Type = "public"
  }
}

resource "aws_subnet" "public_management_1a" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.240.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-${var.service}-subnet-public-management-1a"
    Type = "Public"
  }
}

resource "aws_subnet" "public_management_1c" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.241.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env}-${var.service}-subnet-public-management-1c"
    Type = "Public"
  }
}

resource "aws_subnet" "private_egress_1a" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.248.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.env}-${var.service}-subnet-private-egress-1a"
    Type = "Isolated"
  }
}

resource "aws_subnet" "private_egress_1c" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.249.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.env}-${var.service}-subnet-private-egress-1c"
    Type = "Isolated"
  }
}

data "aws_caller_identity" "self" {}
