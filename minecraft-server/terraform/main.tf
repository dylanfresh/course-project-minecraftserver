terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Ubuntu 24.04 LTS AMI

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Networking

resource "aws_vpc" "minecraft" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "minecraft-vpc"
  }
}

resource "aws_subnet" "minecraft" {
  vpc_id                  = aws_vpc.minecraft.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "minecraft-subnet"
  }
}

resource "aws_internet_gateway" "minecraft" {
  vpc_id = aws_vpc.minecraft.id

  tags = {
    Name = "minecraft-igw"
  }
}

resource "aws_route_table" "minecraft" {
  vpc_id = aws_vpc.minecraft.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.minecraft.id
  }

  tags = {
    Name = "minecraft-route-table"
  }
}

resource "aws_route_table_association" "minecraft" {
  subnet_id      = aws_subnet.minecraft.id
  route_table_id = aws_route_table.minecraft.id
}

# SSH Key

resource "aws_key_pair" "minecraft" {
  key_name   = "minecraft-key"
  public_key = file(var.public_key_path)
}

# Security Group

resource "aws_security_group" "minecraft_sg" {
  name        = "minecraft-security-group"
  description = "Allow SSH and Minecraft traffic"
  vpc_id      = aws_vpc.minecraft.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Minecraft"
    from_port   = 25565
    to_port     = 25565
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
    Name = "minecraft-security-group"
  }
}

# EC2 Instance

resource "aws_instance" "minecraft" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"

  subnet_id = aws_subnet.minecraft.id

  key_name               = aws_key_pair.minecraft.key_name
  vpc_security_group_ids = [aws_security_group.minecraft_sg.id]

  tags = {
    Name = "MinecraftServer"
  }
}
