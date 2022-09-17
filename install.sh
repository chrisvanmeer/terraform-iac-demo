#!/bin/bash
sudo apt update && sudo apt install -y nginx
sudo hostnamectl set-hostname webserver01
echo "Hello World!" | sudo tee /var/www/html/index.html
touch /home/ubuntu/.hushlogin
