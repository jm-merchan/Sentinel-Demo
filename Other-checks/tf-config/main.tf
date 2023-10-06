terraform {
  required_providers {
    aws = {
      version = "~> 3.0"
    }
  }
}

variable "range" {
  type        = list(string)
  description = "CIDR Range"
  default     = ["0.0.0.0/0"]
}

provider "aws" {
  region = "us-east-1" # Change this to your desired AWS region
}

variable "public_key" {
  type = string
  description = "Public Key for EC2"
  sensitive = true
}

data "aws_ami" "latest_ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical's AWS account ID for Ubuntu
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "ssh" {
  name   = "ssh"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2-key"
  public_key = var.public_key
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t3.micro" 
  key_name      = aws_key_pair.ec2_key.key_name

  vpc_security_group_ids = [aws_security_group.ssh.id]

  tags = {
    Name = "ExampleInstance"
  }
}

output "public_ip" {
  value = aws_instance.example.public_ip
}
