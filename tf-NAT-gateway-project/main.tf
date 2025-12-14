# create vpc
resource "aws_vpc" "batch3" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.tag1
  }
}

# create public subnet
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.batch3.id
  cidr_block = var.vpc_public_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = var.vpc_public_tag
  }
}

# create private subnet
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.batch3.id
  cidr_block = var.vpc_private_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = var.vpc_private_tag
  }
}

# Elastic IP for NAT
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}

# NAT Gateway in Public Subnet
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "batch2-nat-gateway"
  }
}

# Create Route Table for Private Subnet
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.batch3.id

  tags = {
    Name = "private-route-table"
  }
}

# Add Route: Private Subnet → NAT Gateway
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgw.id
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}

# create IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.batch3.id
  tags = {
    Name = var.vpc_igw_tag
  }
}

# attach IGW to default router #default_route_table_id
resource "aws_route" "default_internet_route" {
  route_table_id         = aws_vpc.batch3.default_route_table_id 
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  depends_on = [aws_vpc.batch3,aws_internet_gateway.igw]
}

#subnet associate in default router
resource "aws_route_table_association" "public_subnet_association" {
      subnet_id      = aws_subnet.public.id
      route_table_id = aws_vpc.batch3.default_route_table_id
    }

# create security group
resource "aws_security_group" "piyush_ssh_sg" {
  name        = "allow_ssh"
  description = "Allow SSH access"
  vpc_id      = aws_vpc.batch3.id

  ingress {
    description = "SSH"
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
    Name = "piyush_ssh_sg"
  }
}

# create instance on public subnet (used ec2-user os) & attach security group.
resource "aws_instance" "public_instance" {
  ami           = var.ami_public_instance
  instance_type = var.i-type
  tags = {
    Name = "terraform_public_instance",
    Team = "Devops-1",
 Project = "3ri"
  }
associate_public_ip_address = "true"
subnet_id = aws_subnet.public.id
disable_api_termination = var.api-termn
iam_instance_profile = var.role
key_name = var.key_public_instance
vpc_security_group_ids = [
  aws_security_group.piyush_ssh_sg.id
]
}

# create instance on private subnet (used ubuntu os) & attach security group.
resource "aws_instance" "private_instance" {
  ami = var.ami_private_instance
  instance_type = var.i-type
  tags = {
    Name = "terraform_private_instance",
    Team = "Devops-1",
 Project = "3ri"
  }
associate_public_ip_address = "false"
subnet_id = aws_subnet.private.id
disable_api_termination = var.api-termn
iam_instance_profile = var.role
key_name = var.key_private_instance
vpc_security_group_ids = [
  aws_security_group.piyush_ssh_sg.id
]
}