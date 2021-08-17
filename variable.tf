# Let's create variables for our resources in main.tf to implement DRY

# --- SSH Keys --- #
variable "aws_key_name" {
  default = "eng89_filipe"
}

variable "aws_key_path" {
  default = "~/.ssh/eng89_filipe.pem"
}

variable "my_ip" {
  default = "188.211.163.29/32"
}

# --- EC2 Instance --- #
variable "app_ami_id" {
  default = "ami-046036047eac23dc9"
}

variable "ec2_instance_type" {
  default = "t2.micro"
}

variable "name" {
  default = "eng89_filipe_terraform_app"
}

# --- VPC --- #
variable "vpc_name" {
  default = "eng89_filipe_terraform_vpc"
}

variable "cidr_block" {
  default= "10.202.0.0/16"
}

# --- IG and RT --- #
variable "igw_name" {
  default = "eng89_filipe_terraform_igw"
}

variable "rt_name" {
  default = "eng89_filipe_terraform_rt"
}

# --- SG (APP) --- #
variable "sg_app_name" {
  default = "eng89_filipe_terraform_sg_app"
}

# --- Subnet (APP) --- #
variable "subnet_app_name" {
  default = "eng89_filipe_terraform_subnet_app"
}