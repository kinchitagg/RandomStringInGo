#!/bin/bash

sudo apt-get update -y
sudo apt-get install python3-pip -y
sudo pip install awscli

# Add Docker's official GPG key:
sudo apt-get update -y
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 654654309397.dkr.ecr.us-east-1.amazonaws.com

sudo docker pull 654654309397.dkr.ecr.us-east-1.amazonaws.com/randomstring:latest

sudo docker run -dit --name=randomstring -p 8081:8081 654654309397.dkr.ecr.us-east-1.amazonaws.com/randomstring:latest
