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

data "template_file" "user_data" {
    template = file("config.yaml")
}

resource "aws_instance" "server" {
    # Linux AMI
    associate_public_ip_address = true
    ami = "ami-050406429a71aaa64"
    vpc_security_group_ids = [aws_security_group.server_open.id]
    instance_type = "t2.medium"
    user_data = data.template_file.user_data.rendered
    tags = {
        Name = "server"
    }
}

resource "aws_security_group" "server_open" {
    name        = "server_open"
    # SSH 
    ingress {
        from_port   = 22 
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # OpenVpn Server
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # outbound internet access
    egress {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_key_pair" "deployer" {
    key_name = "deployer-key"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCsjFGM8n1GSr6XmOcNd4y/ZoutH8sfVHg/6VEhJcOp/D7kxNco43YdLbIRzwvsDGYr/ZVxPg1ESCnVHtJlLTip9fntiMzZPlfJVV09uha9di3vXTLg2XSnQRfNeAg1lVGSkLHPD5d7zJb6kOCIJEXwc+MqdxljeFFTwrUCEJsKMD+THAZhZH6STmvA8QJwK9egiYDzvSuc51HhYM1OgS9eSiK5ta5Qu2rhr3XO0EbTuik63HdqYVsKlZjNeLMLT+/sL2UKFOYCOdSoLpsbned2LS9HmhKqXUJw6aLWDZgOgQjddWgoWVF2XDBrhKsHBHCfyVGsvMhGZ/2O1pU8Mn74OxTBZqI59CXh5stqxMb5PesXdmrM6XkFq5TS1snVSn9CCjQ9n3DEgiFZGZYDhBmzqijaVSFLa6Hk8NiqzciS8gfccnDgM7QBq/Jbh0PWlMVu/rwrVedYbJrFtJzJoLEUPwwYRMk7g00SjzDlE46TlU8nxQ/e7GIRutFqCPGzlj0= crafty@crafty-end"
}