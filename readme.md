# Terraform

Add env variables to Windows (AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY)

nano main.tf
```bash
# Let's build a script to connect to AWS and download/setup all required de>
# keyword: provider - Let's us connect to the cloud provider we want (AWS)
provider "aws" {

        region = "eu-west-1"
}

# Then we will run terraform init to initialise it
# Then move on to launch AWS services

```