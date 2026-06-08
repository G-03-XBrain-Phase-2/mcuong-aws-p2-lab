resource "aws_vpc" "cdo-03-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_internet_gateway" "cdo-03-igw" {
  vpc_id = aws_vpc.cdo-03-vpc.id

  tags = {
    Name = "${var.group_id}-igw"
  }
}

resource "aws_subnet" "cdo-03-public-subnet-a" {
  vpc_id                  = aws_vpc.cdo-03-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.group_id}-public-subnet"
  }
}
resource "aws_subnet" "cdo-03-public-subnet-b" {
  vpc_id                  = aws_vpc.cdo-03-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.group_id}-public-subnet"
  }
}
resource "aws_subnet" "cdo-03-private-subnet-a" {
  vpc_id            = aws_vpc.cdo-03-vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "${var.group_id}-private-subnet"
  }
}

resource "aws_subnet" "cdo-03-private-subnet-b" {
  vpc_id            = aws_vpc.cdo-03-vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "${var.group_id}-private-subnet"
  }
}

resource "aws_route_table" "cdo-03-public-route-table" {
  vpc_id = aws_vpc.cdo-03-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cdo-03-igw.id
  }
  tags = {
    Name = "${var.group_id}-rt-public"
  }
}
resource "aws_route_table" "cdo-03-private-route-table" {
  vpc_id = aws_vpc.cdo-03-vpc.id
  tags = {
    Name = "${var.group_id}-rt-private"
  }
}

resource "aws_route_table_association" "cdo-03-association-1" {
  subnet_id      = aws_subnet.cdo-03-public-subnet-a.id
  route_table_id = aws_route_table.cdo-03-public-route-table.id
}

resource "aws_route_table_association" "cdo-03-assciation-2" {
  subnet_id      = aws_subnet.cdo-03-public-subnet-b.id
  route_table_id = aws_route_table.cdo-03-public-route-table.id
}

resource "aws_route_table_association" "cdo-03-assciation-3" {
  subnet_id      = aws_subnet.cdo-03-private-subnet-a.id
  route_table_id = aws_route_table.cdo-03-private-route-table.id
}

resource "aws_route_table_association" "cdo-03-assciation-4" {
  subnet_id      = aws_subnet.cdo-03-private-subnet-b.id
  route_table_id = aws_route_table.cdo-03-private-route-table.id
}


