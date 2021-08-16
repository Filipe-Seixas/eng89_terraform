# Let's create variables for our resources in main.tf to implement DRY

variable "aws_key_name" {
  default = "eng89_filipe"
}

variable "aws_key_path" {
  default = "~/.ssh/eng89_filipe.pem"
}

variable "ami_id" {
  default = "ami-038d7b856fe7557b3"
}

variable "ec2_instance_type" {
  default = "t2.micro"
}