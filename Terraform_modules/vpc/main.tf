resource "aws_vpc" "Vpc_Ter" {
  cidr_block  = var.cidr_block
  instance_tenancy = "default"

  tags = {
    "Name" = "${var.environment} vpc"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_internet_gateway" "gwT" {
  vpc_id = aws_vpc.Vpc_Ter.id

  tags = {
    Name = "${var.environment} gateway"
  }
}

resource "aws_route_table" "route_public" {
  vpc_id = aws_vpc.Vpc_Ter.id

  route {
    cidr_block = var.route_public_cidr_block
    gateway_id = aws_internet_gateway.gwT.id
  }

  tags = {
    Name = "${var.environment}-public_route table"
  }
}


resource "aws_subnet" "Public" {
  count                   = var.public_count
  vpc_id                  = aws_vpc.Vpc_Ter.id
  cidr_block              = element(var.public_cidr_block,count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = "true"

  tags = {
    Name = "${var.environment}-public subnet"
  }
}

resource "aws_subnet" "Private" {
  count                  = var.private_count
  vpc_id                 = aws_vpc.Vpc_Ter.id
  cidr_block             = element(var.private_cidr_block,count.index)
  availability_zone      = data.aws_availability_zones.available.names[count.index]
  
  tags = {
    Name = "${var.environment}-private subnet"
  }
}

resource "aws_route_table_association" "public" {
  count          = length (aws_subnet.Public[*])
  subnet_id      = element(aws_subnet.Public[*].id,count.index)
  route_table_id = aws_route_table.route_public.id
}



/*
resource "aws_nat_gateway" "nat-get" {
  subnet_id     = aws_subnet.Private1.id

  tags = {
    Name = "gw NAT"
  }
  depends_on = [aws_internet_gateway.gwT]
}
*/