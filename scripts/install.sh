#!/bin/bash
sudo apt update && sudo apt install -y nginx
sudo hostnamectl set-hostname ${hostname}
echo "Hello World - ${provider}!" | sudo tee /var/www/html/index.html
