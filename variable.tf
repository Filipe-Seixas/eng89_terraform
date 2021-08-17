# Let's create variables for our resources in main.tf to implement DRY

# --- General --- #
variable "aws_key_name" {
  default = "eng89_filipe"
}

variable "aws_key_path" {
  default = "~/.ssh/eng89_filipe.pem"
}

variable "my_ip" {
  default = "188.211.163.29/32"
}

variable "region" {
  default = "eu-west-1"
}

variable "avail_zone" {
  default = "eu-west-1a"
}

variable "ec2_instance_type" {
  default = "t2.micro"
}

# --- APP Instance --- #
variable "app_ami_id" {
  default = "ami-046036047eac23dc9"
}

variable "app_name" {
  default = "eng89_filipe_terraform_app"
}

variable "app_ip" {
  default = "10.202.1.0/24"
}

# --- DB Instance --- #
variable "db_ami_id" {
  default = "ami-0a2a0deac91474c88"
}

variable "db_name" {
  default = "eng89_filipe_terraform_db"
}

variable "db_ip" {
  default = "10.202.2.0/24"
}

# --- BASTION Instance --- #
variable "bastion_ami_id" {
  default = "ami-038d7b856fe7557b3"
}

variable "bastion_name" {
  default = "eng89_filipe_terraform_bastion"
}

variable "bastion_ip" {
  default = "10.202.3.0/24"
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

# --- SGs --- #
variable "sg_app_name" {
  default = "eng89_filipe_terraform_sg_app"
}

variable "sg_db_name" {
  default = "eng89_filipe_terraform_sg_db"
}

variable "sg_bastion_name" {
  default = "eng89_filipe_terraform_sg_bastion"
}

# --- NACLs --- #
variable "nacl_app_name" {
  default = "eng89_filipe_terraform_nacl_app"
}

variable "nacl_db_name" {
  default = "eng89_filipe_terraform_nacl_db"
}

variable "nacl_bastion_name" {
  default = "eng89_filipe_terraform_nacl_bastion"
}

# --- Subnets --- #
variable "subnet_app_name" {
  default = "eng89_filipe_terraform_subnet_app"
}

variable "subnet_db_name" {
  default = "eng89_filipe_terraform_subnet_db"
}

variable "subnet_bastion_name" {
  default = "eng89_filipe_terraform_subnet_bastion"
}