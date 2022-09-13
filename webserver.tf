resource "aws_instance" "web_server" {
  ami           = "ami-065deacbcaac64cf2"
  instance_type = "t2.micro"
  key_name      = "chrisvanmeer-keypair"
  user_data     = file("install.sh")
  tags = {
    Name = "webserver01"
  }
}

output "webserver01_public_ip" {
  value = aws_instance.web_server.public_ip
}







