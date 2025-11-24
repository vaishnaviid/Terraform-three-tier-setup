terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
    }
  }
}

provider "aws" {
    region = var.region
}

resource "aws_vpc" "vpc_3tier" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "3-tier-vpc"
    }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc_3tier.id
  cidr_block              = var.pub_sub_cidr
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc_3tier.id
  cidr_block        = var.pri_sub_cidr
  availability_zone = var.availability_zones[1]
}
