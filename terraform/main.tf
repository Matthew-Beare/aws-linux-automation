terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_security_group" "ssh_limited" {
  name_prefix = "linux-admin-lab-"
  description = "SSH from trusted administrator CIDR only"
  vpc_id      = var.vpc_id

  ingress {
    description = "Restricted administrative SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "linux" {
  for_each                    = var.instances
  ami                         = each.value.ami_id
  instance_type               = each.value.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.ec2_key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ssh_limited.id]

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "portfolio-${each.key}"
  }
}
