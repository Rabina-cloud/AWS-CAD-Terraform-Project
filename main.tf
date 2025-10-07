resource "aws_vpc" "customvpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "CustomVPC"
  }
}

resource "aws_internet_gateway" "customIGW" {
  vpc_id = aws_vpc.customvpc.id

  tags = {
    Name = "CustomIGW"
  }
}

resource "aws_route_table" "publicRT" {
  vpc_id = aws_vpc.customvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.customIGW.id
  }

  tags = {
    Name = "PublicRT"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.customvpc.id
  cidr_block              = var.subnet1_cidr
  availability_zone       = var.AZ1
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.customvpc.id
  cidr_block        = var.subnet2_cidr
  availability_zone = var.AZ1

  tags = {
    Name = "Subnet-2"
  }
}

resource "aws_subnet" "subnet3" {
  vpc_id                  = aws_vpc.customvpc.id
  cidr_block              = var.subnet3_cidr
  availability_zone       = var.AZ2
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-3"
  }
}

resource "aws_subnet" "subnet4" {
  vpc_id            = aws_vpc.customvpc.id
  cidr_block        = var.subnet4_cidr
  availability_zone = var.AZ2

  tags = {
    Name = "Subnet-4"
  }
}


resource "aws_route_table_association" "subnet1_association" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.publicRT.id
}

resource "aws_route_table_association" "subnet3_association" {
  subnet_id      = aws_subnet.subnet3.id
  route_table_id = aws_route_table.publicRT.id
}

#Security groups
resource "aws_security_group" "PublicEC2SG" {
  name        = "PublicEC2SG"
  description = "Allow inbound trafic on 22, 80 and all outbound traffic"
  vpc_id      = aws_vpc.customvpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "PublicEC2SG"
  }
}

resource "aws_security_group" "PublicALBSG" {
  name        = "PublicALBSG"
  description = "Allow inbound trafic on 80, 443 and all outbound traffic"
  vpc_id      = aws_vpc.customvpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "PublicALBSG"
  }
}

