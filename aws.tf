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
    ingress {
        from_port   = 0 
        to_port     = 0
        protocol    = "-1"
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
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDXCIZd6AG2mt5ROzKLlg3/D0O0MouU6BWhNv0jHmOb9v/unACu0RWPkdeFGIEPUE+v3XQrOgNKdg6v3IDcGh20w3i56VGl2NBWKY5JCCGTpYx1P+mpKPEp+QzclDjSr8YE+8ZemaddOzCEFUYUGpCwDy6kImHH92By0ZV+ceud2Uz7+nr0cTEEmlt4bPAiy3HStF+7MlI19ZaJ4DuzAKzO9hNF3SzpgyjqFy+nO+IA1+cI1l1UTIehF8SJKkTRuSCMkx5RvHX8IqzcwOTahI/OalCLO8w2QygsaAhVKkT/8sXggZoTKaiuOy6n4gLNtSroJVkrVnXiKnvE0lrpQRzjpfaLx2hIdGv9YZIfkVlDU9eW2z92ZKMuCNen4YVUI4bgWWv8y7f8riRAwASSEBzt9/9gSuLFIaicSYg9me+oz8VwISIZt+znGOOHi4sHHDDxbFX87sJZMA0Oezp1W6SvU+RdB3IYA8hIbi7nBhXzg2C/LFx+fjtbgnd6rGfmtjk= crafty@crafty-laptop"
}