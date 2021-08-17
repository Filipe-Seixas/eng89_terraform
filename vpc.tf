# Create a VPC  
resource "aws_vpc" "prod-vpc" {
  cidr_block       = var.cidr_block 
  instance_tenancy = "default"
  tags = {
    Name = var.vpc_name
  }
}

# Create APP Subnet
resource "aws_subnet" "prod-subnet-public-1" {
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block = "10.202.1.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = var.avail_zone
    tags = {
        Name = var.subnet_app_name
    }
}