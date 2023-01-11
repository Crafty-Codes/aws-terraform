terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.16"
        }
    }
    required_version = ">= 1.2.0"
}
provider "aws" {
    region = "us-east-1"
}
resource "aws_instance" "app_server" {
    ami = "ami-083654bd07b5da81d"
    instance_type = "t2.micro"
    tags = {
        Name = "naas"
    }
}