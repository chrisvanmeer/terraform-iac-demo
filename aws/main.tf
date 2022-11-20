terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.40.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

locals {
  ssh_pub_key_file = "~/.ssh/id_rsa.pub"
}

resource "aws_key_pair" "key" {
  key_name   = "iac-key"
  public_key = file(local.ssh_pub_key_file)
}

resource "aws_instance" "aws_web_server" {
  ami           = "ami-065deacbcaac64cf2"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key.key_name
  user_data     = templatefile("../scripts/install.sh", { hostname = "webserver01", provider = "AWS" })
  tags = {
    Name = "webserver01"
  }
}

output "aws_webserver01_public_ip" {
  value = <<AWS
  The AWS webserver has been deployed.
  SSH details: ubuntu@${aws_instance.aws_web_server.public_ip}
  Webserver details: http://${aws_instance.aws_web_server.public_ip}
  AWS
}
