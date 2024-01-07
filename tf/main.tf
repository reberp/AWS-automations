terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.instance["region"]
}

#create VPC
resource "aws_vpc" "test_vpc" {
  cidr_block       = "10.10.0.0/16"

  tags = {
    Name = "test_vpc"
  }
}

#create subnet and put into vpc 
resource "aws_subnet" "test_subnet" {
  vpc_id     = aws_vpc.test_vpc.id
  cidr_block = "10.10.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "test_subnet"
  }
}

#create IGW and attach to VPC
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "test_gw" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "test_gw"
  }
}

#create routing table and to VPC to send to IGW\
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "test_route_table" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_gw.id
  }

  tags = {
    Name = "test_rt"
  }
}

resource "aws_route_table_association" "test_route_table_association" {
  subnet_id      = aws_subnet.test_subnet.id
  route_table_id = aws_route_table.test_route_table.id
}


#create security group
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "test_sg" {
  name        = "test_sg"
  description = "Allow all SSH and own SG"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    description      = "SSH"
    to_port          = 22
    from_port        = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "own SG"
    to_port          = 0
    from_port        = 0
    protocol         = "all"
    self             = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "test_sg"
  }
}

resource "aws_instance" "app_server" {
  count                   = 2
  ami                     = var.instance["ami_id"]
  instance_type           = var.instance["type"]
  key_name                = var.ec2_keyname           
  vpc_security_group_ids  = [aws_security_group.test_sg.id]
  subnet_id               = aws_subnet.test_subnet.id
  tags = {
    Name = "${var.instance["name"]}.${count.index}"
  }
}

output "instance_ips" {
  value = [for e in aws_instance.app_server : e.public_ip]
}

output "instance_names" {
  value = [for e in aws_instance.app_server : e.tags["Name"]]
}

output "instance_details" {
  value = [for e in aws_instance.app_server : e]
}