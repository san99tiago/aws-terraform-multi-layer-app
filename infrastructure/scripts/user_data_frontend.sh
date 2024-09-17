#!/bin/bash

####################################################################################################
# SCRIPT TO RUN IN THE DEMO SERVERS (FRONTEND)
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


# FRONTEND APP DOWNLOAD AND INSTALLATION
# Create the /var/app directory for the application
sudo mkdir -p /var/app
cd /var/app

# Download the frontend.zip file from the S3 bucket
echo "----- Downloading frontend.zip from S3 -----"
aws s3 cp s3://$S3_BUCKET/frontend.zip /var/app/

# Unzip the frontend.zip file into /var/app
echo "----- Unzipping frontend.zip -----"
sudo unzip -o frontend.zip

# Install npm dependencies
echo "----- Installing npm dependencies -----"
cd /var/app/frontend
sudo npm install

# Start the server with "node server.js" on port 80
echo "----- Starting the Node.js server -----"
node server.js > server.log 2>&1 &
