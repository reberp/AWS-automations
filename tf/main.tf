terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

#locals {
#  vpc-id = "${aws_vpc.test-vpc.id}"
#}
#output "vpc-id" {
#  value = "${local.vpc-id}"
#}

variable "EC2_KEY" {
    type        = string
    description = "This is an example input variable using env variables."
}

provider "aws" {
  region  = var.instance["region"]
}

#create VPC
resource "aws_vpc" "test-vpc" {
  cidr_block       = "10.10.0.0/16"

  tags = {
    Name = "test-vpc"
  }
}

#create subnet and put into vpc 
resource "aws_subnet" "test-subnet" {
  vpc_id     = aws_vpc.test-vpc.id
  cidr_block = "10.10.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "test-subnet"
  }
}

#create IGW and attach to VPC
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "test-gw" {
  vpc_id = aws_vpc.test-vpc.id

  tags = {
    Name = "test-gw"
  }
}

#create routing table and to VPC to send to IGW\
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "test_route_table" {
  vpc_id = aws_vpc.test-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-gw.id
  }

  tags = {
    Name = "test-rt"
  }
}

resource "aws_route_table_association" "test_route_table_association" {
  subnet_id      = aws_subnet.test-subnet.id
  route_table_id = aws_route_table.test_route_table.id
}


#create security group
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.test-vpc.id

  ingress {
    description      = "SSH"
    to_port          = 22
    from_port        = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  # from itself vpc [aws_vpc.main.cidr_block]

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_instance" "app_server" {
  count                   = 1
  ami                     = var.instance["ami-id"]
  instance_type           = var.instance["type"]
  key_name                = var.ec2_keyname           
  vpc_security_group_ids  = [aws_security_group.allow_ssh.id]
  subnet_id               = aws_subnet.test-subnet.id
  tags = {
    Name = "${var.instance["name"]}.${count.index}"
  }
}
#[var.instance["vpc-security-group-ids"]] 

#output "instance_ips" {
#  value = [for e in aws_instance.app_server : e.public_ip]
#}

