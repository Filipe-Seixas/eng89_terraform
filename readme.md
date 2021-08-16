# Terraform

<p align=center>
        <img src=terraform_diagram.PNG>
</p>

### What is Terraform and Benefits

- Terraform is a tool for developing, changing and versioning infrastructure safely and efficiently.
- It's used for the orchestration part of IAC
- Terraform promotes IAC but also focuses on the automation of the infrastructure itself.
        - Competitors: Ansible, Kubernetes, Packer

### IAC Configuration Management vs Orchestration

- ***Configuration Management***:
        - Generally, Ansible, Puppet, Chef are considered to be configuration management (CM) tools and were created to install and manage software on existing server instances (e.g., installation of packages, starting of services, installing scripts or config files on the instance).

- ***Configuration Orchestration***:
        - Tools like Terraform are considered to be orchestrators. They are designed to provision the server instances themselves, leaving the job of configuring those servers to other tools. Orchestration addresses the requirement to provision environments at a higher level than configuration management. The focus here is on coordinating configuration across complex environments and clusters.

## Terraform Set Up

- Add env variables to Windows (AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY) and ***make sure to close and open your terminal***
- Create main.tf file `nano main.tf`
- Specify the ssh key you want to use in your main.tf file

#### main.tf
```bash
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
```

- `terraform init` to initialise terraform
- `terraform plan` to check and preview the changes that will happen to the infrastructure
- `terraform apply` to commit the changes
- `terraform destroy` to destroy instance

### Variables

- We can also set up variables in a separate file and call them in main.tf
```bash
variable "aws_key_name" {
  default = "eng89_filipe"
}

variable "aws_key_path" {
  default = "~/.ssh/eng89_filipe.pem"
}
```
- We can call them using `key_name = var.aws_key_name`

# Network Configuration Task

<p align=center>
        <img src=terraform_network_diagram.png>
</p>

- Create a VPC, IP: 10.202.0.0/16
- Create an Internet Gateway and attach it
- Create a Route Table with route 0.0.0.0/0 for all traffic allowed

## Public Server, APP

- Create the public Subnet and associate the RT, IP: 10.202.1.0/24
- Create a NACL for the Subnet with following rules:

### NACL

#### Inbound Rules

| Inbound Type | Protocol | Port Range   | Source     |
|--------------|----------|--------------|------------|
| HTTP (80)    | TCP (6)  | 80           | 0.0.0.0/0  |
| SSH (22)     | TCP (6)  | 22           | [My IP]/32 |
| Custom TCP   | TCP (6)  | 1024 - 65535 | 0.0.0.0/0  |

#### Outbound Rules

| Outbound Type | Protocol | Port Range   | Destination   |
|---------------|----------|--------------|---------------|
| HTTP (80)     | TCP (6)  | 80           | 0.0.0.0/0     |
| Custom TCP    | TCP (6)  | 27017        | 10.202.2.0/24 |
| Custom TCP    | TCP (6)  | 1024 - 65535 | 0.0.0.0/0     |

- Create a Security Group with the following rules:

### SG

#### Inbound Rules

| Inbound Type | Protocol | Port Range | Source     |
|--------------|----------|------------|------------|
| HTTP (80)    | TCP (6)  | 80         | 0.0.0.0/0  |
| SSH (22)     | TCP (6)  | 22         | [My IP]/32 |

#### Outbound Rules

| Outbound Type | Protocol | Port Range   | Destination   |
|---------------|----------|--------------|---------------|
| HTTP (80)     | TCP (6)  | 80           | 0.0.0.0/0     |

## Private Server, DB

- Create the DB Subnet, IP: 10.202.2.0/24 (NO NEED FOR RT)
- Create a NACL for the Subnet with following rules:

### NACL

#### Inbound Rules

| Inbound Type | Protocol | Port Range   | Source        |
|--------------|----------|--------------|---------------|
| Custom TCP   | TCP (6)  | 27017        | 10.202.1.0/24 |
| Custom TCP   | TCP (6)  | 1024 - 65535 | 0.0.0.0/0     |
| SSH (22)     | TCP (6)  | 22           | 10.202.3.0/24 |

#### Outbound Rules

| Outbound Type | Protocol | Port range   | Destination   |
|---------------|----------|--------------|---------------|
| HTTP (80)     | TCP (6)  | 80           | 0.0.0.0/0     |
| Custom TCP    | TCP (6)  | 1024 - 65535 | 10.202.1.0/24 |
| Custom TCP    | TCP (6)  | 1024 - 65535 | 10.202.3.0/24 |

- Create a Security Group with the following rules:

### SG

#### Inbound Rules

| Inbound Type | Protocol | Port range | Source             |
|--------------|----------|------------|--------------------|
| Custom TCP   | TCP (6)  | 27017      | Custom: APP_SG     |
| SSH (22)     | TCP (6)  | 22         | Custom: BASTION_SG |

#### Outbound Rules

| Inbound Type | Protocol | Source        |
|--------------|----------|---------------|
| All Traffic  | TCP (6)  | Anywhere-IPv4 |

## Security Private Server, BASTION

- Create the Bastion Subnet and associate the RT, IP: 10.202.3.0/24
- Create a NACL for the Subnet with following rules:

### NACL

#### Inbound Rules

| Inbound Type | Protocol | Port range   | Source        |
|--------------|----------|--------------|---------------|
| SSH (22)     | TCP (6)  | 22           | My IP/32      |
| Custom TCP   | TCP (6)  | 1024 - 65535 | 10.202.2.0/24 |

#### Outbound Rules

| Outbound Type | Protocol | Port range   | Destination   |
|---------------|----------|--------------|---------------|
| SSH (22)      | TCP (6)  | 22           | 10.202.2.0/24 |
| Custom TCP    | TCP (6)  | 1024 - 65535 | 0.0.0.0/0     |

### SG

#### Inbound Rules

| Inbound Type | Protocol | Port Range | Source     |
|--------------|----------|------------|------------|
| SSH (22)     | TCP (6)  | 22         | [My IP]/32 |

#### Outbound Rules

| Inbound Type | Protocol | Source        |
|--------------|----------|---------------|
| All Traffic  | TCP (6)  | Anywhere-IPv4 |