# Let's build a script to connect to AWS and download/setup all required dependencies

#provider - Let's us connect to the cloud provider we want (AWS)
provider "aws" {
	region = var.region
}

# Launch EC2 Instance - APP
resource "aws_instance" "app_instance" {
	
	# SSH key name
	key_name = var.aws_key_name
	ami = var.app_ami_id
	instance_type = var.ec2_instance_type
	subnet_id = aws_subnet.prod-subnet-public-1.id
	vpc_security_group_ids = [aws_security_group.ssh-allowed.id]
	# Give public IP
	associate_public_ip_address = true
	tags = {
		Name = var.name
	}
}
