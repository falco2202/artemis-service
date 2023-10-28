resource "aws_vpc" "artemis" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_internet_gateway" "artemis_igw" {
  vpc_id = aws_vpc.artemis.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

resource "aws_subnet" "public_subnets" {
  vpc_id            = aws_vpc.artemis.id
  cidr_block        = var.public_subnets_cidr_block[count.index]
  availability_zone = var.availability_zones[count.index]
  count             = length(var.public_subnets_cidr_block)

  tags = {
    Name = "${var.project_name}-public-subnet-${count.index}"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.artemis.id

  tags = {
    Name = "${var.project_name}-public-route-table"
  }
}

resource "aws_route" "public_rtb" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.artemis_igw.id
}

resource "aws_route_table_association" "public_subnet" {
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
  count          = length(var.public_subnets_cidr_block)
}

resource "aws_subnet" "database_subnets" {
  vpc_id            = aws_vpc.artemis.id
  count             = length(var.database_subnets_cidr_block)
  cidr_block        = var.database_subnets_cidr_block[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.project_name}-database-subnet-${count.index}"
  }
}

resource "aws_route_table" "database_route_table" {
  vpc_id = aws_vpc.artemis.id

  tags = {
    Name = "${var.project_name}-database-route-table"
  }
}

resource "aws_route_table_association" "database_subnet" {
  subnet_id      = aws_subnet.database_subnets[count.index].id
  route_table_id = aws_route_table.database_route_table.id
  count          = length(var.database_subnets_cidr_block)
}

resource "aws_security_group" "public_sg" {
  name        = "${var.project_name}-public-sg"
  description = "Default SG to allow traffic from the VPC"
  vpc_id      = aws_vpc.artemis.id

  depends_on = [aws_vpc.artemis]

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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
    Name = "${var.project_name}-public-sg"
  }
}

resource "aws_security_group" "agent_sg" {
  name   = "${var.project_name}-agent-sg"
  vpc_id = aws_vpc.artemis.id

  depends_on = [aws_vpc.artemis]

  ingress {
    from_port   = 22
    to_port     = 22
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
    Name = "${var.project_name}-agent-sg"
  }
}

resource "aws_security_group" "database_sg" {
  name        = "${var.project_name}-database-sg"
  description = "Default SG to allow traffic from the VPC"
  vpc_id      = aws_vpc.artemis.id

  depends_on = [aws_security_group.public_sg]

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.public_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-database-sg"
  }
}

resource "aws_security_group" "efs_sg" {
  name   = "${var.project_name}-efs-sg"
  vpc_id = aws_vpc.artemis.id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }
}
