terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# =======================
# VPC
# =======================
resource "aws_vpc" "vpc_3tier" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "3-tier-vpc"
  }
}

# =======================
# Public Subnet
# =======================
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc_3tier.id
  cidr_block              = var.pub_sub_cidr
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
}

# =======================
# Private Subnet
# =======================
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc_3tier.id
  cidr_block        = var.pri_sub_cidr
  availability_zone = var.availability_zones[1]
}

# =======================
# Internet Gateway
# =======================
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_3tier.id
  tags = {
    Name = "3-tier-igw"
  }
}

# =======================
# Public Route Table
# =======================
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_3tier.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# =======================
# Elastic IP for NAT Gateway
# =======================
resource "aws_eip" "nat_eip" {
  vpc = true
}

# =======================
# NAT Gateway (in public subnet)
# =======================
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "nat-gateway"
  }
}

# =======================
# Private Route Table (for private subnet)
# =======================
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc_3tier.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private-rt"
  }
}

resource "aws_route_table_association" "private_rt_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}
