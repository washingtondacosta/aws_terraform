data "aws_availability_zones" "azs" {

}

resource "aws_vpc" "primary" {
  cidr_block = "172.0.0.0/16"

  tags = {
    "Name" = "VPC-TF"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.primary.id

  tags = {
    "Name" = "Gateway"
  }
}

resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.primary.id
  cidr_block        = "172.0.1.0/24"
  availability_zone = "${var.aws_reg}a"
  tags = {
    "Name" = "Public a"
  }
}

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.primary.id
  cidr_block        = "172.0.2.0/24"
  availability_zone = "${var.aws_reg}a"
  tags = {
    "Name" = "Private a"
  }
}

resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.primary.id
  cidr_block        = "172.0.3.0/24"
  availability_zone = "${var.aws_reg}b"
  tags = {
    "Name" = "Public b"
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.primary.id
  cidr_block        = "172.0.4.0/24"
  availability_zone = "${var.aws_reg}b"
  tags = {
    "Name" = "Private b"
  }
}

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.primary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name" = "Terraform - Public"
  }
}

resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.primary.id

  tags = {
    "Name" = "Terraform - Private"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.rt_private.id
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.private1.id, aws_subnet.private2.id]

  tags = {
    Name = "Subnet Group DB"
  }
}