#!/bin/bash
####################################################################################################
# SCRIPT TO DEPLOY INFRASTRUCTURE RESOURCES (TERRAFORM)
####################################################################################################

cd infrastructure
terraform init
terraform apply -auto-approve
