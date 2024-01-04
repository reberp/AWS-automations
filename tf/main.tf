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

resource "aws_instance" "app_server" {
  ami           = var.instance["ami-id"]
  instance_type = var.instance["type"]

  tags = {
    Name = var.instance["name"]
  }
}
