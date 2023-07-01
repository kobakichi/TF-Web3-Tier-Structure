locals {
  public_subnet_ids = aws_subnet.public.*.id
}

locals {
  private_subnet_ids = aws_subnet.private.*.id
}

# -----------------------------
# VPC
# -----------------------------
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.prefix}-vpc"
  }
}

# ------------------------------
# Public Subnets
# ------------------------------
resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 1)

  tags = {
    Name = "${var.prefix}-public-${var.az_place[count.index]}"
  }
}

output "public_subnet_ids" {
  value = local.public_subnet_ids
}

# ------------------------------
# Private Subnets
# ------------------------------
resource "aws_subnet" "private" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  availability_zone       = var.availability_zones[count.index]
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 11)
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.prefix}-private-${var.az_place[count.index]}"
  }
}

output "private_subnet_ids" {
  value = local.private_subnet_ids
}

# ------------------------------
# internetgateway
# ------------------------------
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.prefix}-vpc-igw"
  }
}

# ------------------------------
# Route Table Public
# ------------------------------
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.prefix}-public-route-table"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public_rtb.id
  gateway_id             = aws_internet_gateway.main.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  for_each       = toset(local.public_subnet_ids)
  route_table_id = aws_route_table.public_rtb.id
  subnet_id      = each.value
}

# ------------------------------
# Route Table Private
# ------------------------------

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

    tags = {
    Name = "${var.prefix}-private-route-table"
  }
}

resource "aws_route_table_association" "private" {
  for_each       = toset(local.private_subnet_ids)
  route_table_id = aws_route_table.private.id
  subnet_id      = each.value
}