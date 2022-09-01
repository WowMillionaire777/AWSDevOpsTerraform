provider "aws" {
  region = "us-east-1"
  //version = "~> 2.46" (No longer necessary)
}

# resource "aws_s3_bucket" "tf_state_bucket" {
#   bucket = "tf-dev-state-123"

#   tags = {
#     Name = "State Bucket"
#   }
# }

resource "aws_instance" "my_vm" {
  ami           = local.ami //Ubuntu AMI
  instance_type = var.instance_type

  tags = {
    Name = var.name_tag,
  }
}