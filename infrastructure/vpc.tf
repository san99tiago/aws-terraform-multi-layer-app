############################################
# VPC
############################################

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

############################################
# PUBLIC SUBNETS
############################################

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-vpc-igw"
  }
}

resource "aws_subnet" "public" {
  count = length(var.vpc_public_subnets_cidr)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.vpc_public_subnets_cidr, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

############################################
# PRIVATE SUBNETS
############################################

resource "aws_eip" "nat" {
  count = var.enable_nat_gateway ? 1 : 0

  domain = "vpc"
}

resource "aws_nat_gateway" "main" {
  count         = var.enable_nat_gateway ? 1 : 0 // Intentionally set to 1 to avoid creating multiple NAT Gateways (costs)
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id // NATS are placed in the public subnet

  tags = {
    Name = "nat-gateway-${count.index + 1}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency to IGW
  depends_on = [aws_internet_gateway.main]
}

resource "aws_subnet" "private" {
  count = length(var.vpc_private_subnets_cidr)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.vpc_private_subnets_cidr, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "private" {
  count = var.enable_nat_gateway ? 1 : 0

  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main[0].id
  }
}

resource "aws_route_table_association" "private" {
  count = var.enable_nat_gateway ? length(aws_subnet.private) : 0

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[0].id
}
