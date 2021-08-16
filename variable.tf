# Let's create variables for our resources in main.tf to implement DRY

variable "aws_key_name" {
  default = "eng89_filipe"
}

variable "aws_key_path" {
  default = "~/.ssh/eng89_filipe.pem"
}