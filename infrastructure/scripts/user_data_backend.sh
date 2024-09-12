#!/bin/bash

####################################################################################################
# SCRIPT TO RUN IN THE DEMO SERVERS (BACKEND)
####################################################################################################

# Enable extra logging
set -x

# Install amazon linux extras
sudo yum install -y amazon-linux-extras

# Install extra packages
curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
sudo dnf update -y
sudo dnf install -y mariadb105
sudo dnf install -y nodejs

# Refresh environment variables
source /etc/profile

# Update OS
echo "----- Updating OS -----"
sudo yum update -y

# Install and Initialize SSM Agent
# --> Note: hard-coded to us-east-1 region.. update to dynamic ref
echo "----- Initializing SSM Agent -----"
sudo yum install -y https://s3.us-east-1.amazonaws.com/amazon-ssm-us-east-1/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

# Install Apache server
sudo yum update -y
sudo yum install -y httpd

# Start and enable Apache server with sample content
sudo systemctl enable httpd
sudo systemctl start httpd
sudo echo "<html><h1>BACKEND APACHE SEVER WORKING</h1></html>" > /var/www/html/index.html


# TODO: ADD BACKEND DOWNLOAD AND INSTALLATION SCRIPTS
