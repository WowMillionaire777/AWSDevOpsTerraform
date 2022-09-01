variable "region" {}
variable "public_key_path" {}
variable "key_name" {}
variable "amis" {
    type = map
    default = {
        region = "us-east-1"
        ami    = "amzn2-ami-hvm-*"
    }
}



