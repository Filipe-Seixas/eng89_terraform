# Let's build a script to connect to AWS and download/setup all required dependencies

#provider - Let's us connect to the cloud provider we want (AWS)
provider "aws" {
	region = "eu-west-1"
}

# Create a VPC  
resource "aws_vpc" "prod-vpc" {
  cidr_block       = var.cidr_block 
  instance_tenancy = "default"
  tags = {
    Name = var.vpc_name
  }
}

# Create a Subnet
resource "aws_subnet" "prod-subnet-public-1" {
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block = "10.202.1.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "eu-west-1a"
    tags = {
        Name = var.subnet_app_name
    }
}

# Create Internet Gateway
resource "aws_internet_gateway" "prod-igw" {
  vpc_id = aws_vpc.prod-vpc.id
  
  tags = {
    Name = var.igw_name
  }
}

# Create Route Table
resource "aws_route_table" "prod-public-crt" {
    vpc_id = aws_vpc.prod-vpc.id
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        //CRT uses this IGW to reach internet
        gateway_id = aws_internet_gateway.prod-igw.id
    }
    tags = {
        Name = var.rt_name
    }
}

# Associate it with subnet
resource "aws_route_table_association" "prod-crta-public-subnet-1"{
    subnet_id = aws_subnet.prod-subnet-public-1.id
    route_table_id = aws_route_table.prod-public-crt.id
}

# Create Security Group
resource "aws_security_group" "ssh-allowed" {
    vpc_id = aws_vpc.prod-vpc.id
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }
    //If you do not add this rule, you can not reach the NGINX  
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = var.sg_app_name
    }
}

# Launch EC2 Instance - APP
resource "aws_instance" "app_instance" {
	
	# SSH key name
	key_name = var.aws_key_name
	ami = var.app_ami_id
	instance_type = var.ec2_instance_type
	# Give public IP
	associate_public_ip_address = true
	tags = {
		Name = var.name
	}
}
