locals {
  ami = data.aws_ami.aws_linux_2_latest.id
}

variable "instance_type" {
  type        = string
  description = "Instance type"
}

variable "name_tag" {
  type        = string
  description = "Name of the EC2 instance"
}

