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

# Associate RT with Subnets
resource "aws_route_table_association" "prod-crta-subnet-app"{
    subnet_id = aws_subnet.prod-subnet-app.id
    route_table_id = aws_route_table.prod-public-crt.id
}

resource "aws_route_table_association" "prod-crta-subnet-bastion"{
    subnet_id = aws_subnet.prod-subnet-bastion.id
    route_table_id = aws_route_table.prod-public-crt.id
}



# Create APP Security Group
resource "aws_security_group" "app_sg"{
    vpc_id = aws_vpc.prod-vpc.id
    
    # INBOUND
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }
    ingress {
        from_port = 3000
        to_port = 3000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    } 
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    # OUTBOUND
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = var.sg_app_name
    }
}

# Create APP NACL
resource "aws_network_acl" "app_nacl" {
  vpc_id = aws_vpc.prod-vpc.id
  subnet_ids = [aws_subnet.prod-subnet-app.id]

    # INBOUND
    ingress {
        protocol   = "tcp"
        rule_no    = 100
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 80
        to_port    = 80
    }
    ingress {
        protocol   = "tcp"
        rule_no    = 110
        action     = "allow"
        cidr_block = var.my_ip
        from_port  = 22
        to_port    = 22
    }
    ingress {
        protocol   = "tcp"
        rule_no    = 120
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 1024
        to_port    = 65535
    }
    # OUTBOUND
    egress {
        protocol   = "tcp"
        rule_no    = 100
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 80
        to_port    = 80
    }
    egress {
        protocol   = "tcp"
        rule_no    = 110
        action     = "allow"
        cidr_block = var.my_ip
        from_port  = 22
        to_port    = 22
    }
    egress {
        protocol   = "tcp"
        rule_no    = 120
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 1024
        to_port    = 65535
    }

  tags = {
    Name = var.nacl_app_name
  }
}



# Create DB Security Group
resource "aws_security_group" "db_sg"{
    vpc_id = aws_vpc.prod-vpc.id
    
    # INBOUND
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.bastion_ip]
    }
    ingress {
        from_port = 27017
        to_port = 27017
        protocol = "tcp"
        cidr_blocks = [var.app_ip]
    }
    # OUTBOUND
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = var.sg_db_name
    }
}

# Create DB NACL
resource "aws_network_acl" "db_nacl" {
  vpc_id = aws_vpc.prod-vpc.id
  subnet_ids = [aws_subnet.prod-subnet-db.id]

    # INBOUND
    ingress {
        protocol   = "tcp"
        rule_no    = 100
        action     = "allow"
        cidr_block = var.app_ip
        from_port  = 27017
        to_port    = 27017
    }
    ingress {
        protocol   = "tcp"
        rule_no    = 110
        action     = "allow"
        cidr_block = var.bastion_ip
        from_port  = 22
        to_port    = 22
    }
    ingress {
        protocol   = "tcp"
        rule_no    = 120
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 1024
        to_port    = 65535
    }
    # OUTBOUND
    egress {
        protocol   = "tcp"
        rule_no    = 100
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 80
        to_port    = 80
    }
    egress {
        protocol   = "tcp"
        rule_no    = 110
        action     = "allow"
        cidr_block = var.app_ip
        from_port  = 1024
        to_port    = 65535
    }
    egress {
        protocol   = "tcp"
        rule_no    = 120
        action     = "allow"
        cidr_block = var.bastion_ip
        from_port  = 1024
        to_port    = 65535
    }

  tags = {
    Name = var.nacl_db_name
  }
}



# Create BASTION Security Group
resource "aws_security_group" "bastion_sg"{
    vpc_id = aws_vpc.prod-vpc.id
    
    # INBOUND
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [var.my_ip]
    }
    # OUTBOUND
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = var.sg_bastion_name
    }
}

# Create BASTION NACL
resource "aws_network_acl" "bastion_nacl" {
  vpc_id = aws_vpc.prod-vpc.id
  subnet_ids = [aws_subnet.prod-subnet-bastion.id]

    # INBOUND
    ingress {
        protocol   = "tcp"
        rule_no    = 100
        action     = "allow"
        cidr_block = var.my_ip
        from_port  = 22
        to_port    = 22
    }
    ingress {
        protocol   = "tcp"
        rule_no    = 110
        action     = "allow"
        cidr_block = var.db_ip
        from_port  = 1024
        to_port    = 65535
    }
    # OUTBOUND
    egress {
        protocol   = "tcp"
        rule_no    = 100
        action     = "allow"
        cidr_block = var.db_ip
        from_port  = 22
        to_port    = 22
    }
    egress {
        protocol   = "tcp"
        rule_no    = 110
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 1024
        to_port    = 65535
    }

  tags = {
    Name = var.nacl_bastion_name
  }
}