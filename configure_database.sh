#!/bin/bash

####################################################################################################
# SCRIPT TO CONFIGURE DATABASE (MANUALLY ONLY ONCE)
# # TODO: ADD AUTOMATION SCRIPT AT DEPLOYMENT
####################################################################################################

# 1. Connect to the jump-box instance (via SSH or SSM)
# Example: ssh -i "KEY.pem" ec2-user@JUMP_BOX_PUBLIC_IP

# 2. Connect to the database instance (via mysql client)
# Example: mysql -h ENDPOINT -P 3306 -u USER -p"${DB_PASSWORD}"

# 3. Run the initial SQL scripts (see them in the infrastructure/database folder)
