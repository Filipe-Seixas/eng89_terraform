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
	subnet_id = aws_subnet.prod-subnet-app.id
	vpc_security_group_ids = [aws_security_group.app_sg.id]
	# Give public IP
	associate_public_ip_address = true

	provisioner "file" {
		source      = "provision_app.sh"
		destination = "/home/ubuntu/provision_app.sh"

    	connection {
      		type        = "ssh"
      		user        = "ubuntu"
      		private_key = file(var.aws_key_path)
      		host        = self.public_ip
    	}
  	}
  # runs commands in instance
  provisioner "remote-exec" {
  	inline = [
  		"chmod +x provision_app.sh",
  		"sh provision_app.sh",
  		]
  	connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.aws_key_path)
      host        = self.public_ip
    }
  }
	tags = {
		Name = var.app_name
	}
}

# Launch EC2 Instance - DB
resource "aws_instance" "db_instance" {
	
	# SSH key name
	key_name = var.aws_key_name
	ami = var.db_ami_id
	instance_type = var.ec2_instance_type
	subnet_id = aws_subnet.prod-subnet-db.id
	vpc_security_group_ids = [aws_security_group.db_sg.id]
	# Give public IP
	associate_public_ip_address = false
	tags = {
		Name = var.db_name
	}
}

# Launch EC2 Instance - BASTION
resource "aws_instance" "bastion_instance" {
	
	# SSH key name
	key_name = var.aws_key_name
	ami = var.bastion_ami_id
	instance_type = var.ec2_instance_type
	subnet_id = aws_subnet.prod-subnet-bastion.id
	vpc_security_group_ids = [aws_security_group.bastion_sg.id]
	# Give public IP
	associate_public_ip_address = true

	# provisioner "file" {
 #    source      = "C:/Users/pabfi/.ssh/eng89_filipe.pem"
 #    destination = "/home/ubuntu/.ssh"

 #    connection {
 #      type        = "ssh"
 #      user        = "ubuntu"
 #      private_key = file(var.aws_key_path)
 #      host        = self.public_ip
 #    }
 #  }

	tags = {
		Name = var.bastion_name
	}
}