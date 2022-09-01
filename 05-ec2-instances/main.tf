provider "aws" {
  region  = "us-east-1"
  //version = "~> 2.46" (No longer necessary)
}

resource "aws_default_vpc" "default" {

}

//HTTP Server -> SG
//SG 80 TCP, 22 TCP, CIDR ["0.0.0.0/0"]

resource "aws_security_group" "http_server_sg" {
  vpc_id = "vpc-0cbc98d2667f37c82"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP Inbound"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH Inbound"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow from Everywhere"
    from_port   = 0
    protocol    = -1
    to_port     = 0
  }

  tags = {
    name = "http_server_sg"
  }
}

resource "aws_instance" "http_server" {
  ami                    = "ami-090fa75af13c156b4"
  key_name               = "default-ec2"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]
  subnet_id              = "subnet-0748f5d0412ddcb71"
}








