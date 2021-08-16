# Let's build a script to connect to AWS and download/setup all required dependencies

# keyword: provider - Let's us connect to the cloud provider we want (AWS)

provider "aws" {

	region = "eu-west-1"
}

# Then we will run terraform init to initialise it
# Then move on to launch AWS services

# Let's launch an ec2 instance in eu-west-1 with:
# keyword called "resource" provide resource name and give name with specific details to the service
# resource aws_ec2_instance, name it as eng89_filipe_terraform, ami, type of instance, with or without ip
# tags is the keyword to name the instance

resource "aws_instance" "app_instance" {
	
	key_name = "eng89_filipe"
	ami = "ami-038d7b856fe7557b3"
	instance_type = "t2.micro"
	associate_public_ip_address = true
	tags = {
		Name = "eng89_filipe_terraform"
	}
}


# Most commonly used commands for terraform:
# terraform plan, checks the syntax and validates the instruction we have provided in this script

# Once we are happy and the outcome is green we could run terraform apply
