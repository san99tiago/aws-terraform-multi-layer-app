############################################
# UPLOAD SOURCES FOR THE APP TO S3 BUCKET AT DEPLOYMENT
# Note: for production deployments, a more advanced CI/CD pipeline is recommended
# >> Maybe even with Ansible or Chef for configuration management.
############################################

# Null resource to trigger the backend script
resource "null_resource" "upload_backend_to_s3" {
  # Trigger the resource every time by using a random id
  triggers = {
    always_run = "${timestamp()}" # Ensures this runs every time
  }

  provisioner "local-exec" {
    command = <<EOT
#!/bin/bash

# Change to the root directory
cd ..

# Path to the backend folder
BACKEND_PATH="./backend"
ZIP_FILE="./infrastructure/backend.zip"

# Define the S3 bucket
S3_BUCKET="${var.app_name}-source-files-${data.aws_caller_identity.current.account_id}"

# Zip the backend folder, excluding node_modules
zip -r $ZIP_FILE $BACKEND_PATH -x "$BACKEND_PATH/node_modules/*"

# Upload the zip file to S3
aws s3 cp $ZIP_FILE s3://$S3_BUCKET/
EOT
  }

  # Ensure the S3 bucket exists before running the script
  depends_on = [aws_s3_bucket.source_files]
}


# Null resource to trigger the frontend script
resource "null_resource" "upload_frontend_to_s3" {
  # Trigger the resource every time by using a random id
  triggers = {
    always_run = "${timestamp()}" # Ensures this runs every time
  }

  provisioner "local-exec" {
    command = <<EOT
#!/bin/bash

# Change to the root directory
cd ..

# Path to the frontend folder
FRONTEND_PATH="./frontend"
ZIP_FILE="./infrastructure/frontend.zip"

# Define the S3 bucket
S3_BUCKET="${var.app_name}-source-files-${data.aws_caller_identity.current.account_id}"

# Zip the frontend folder, excluding node_modules
zip -r $ZIP_FILE $FRONTEND_PATH -x "$FRONTEND_PATH/node_modules/*"

# Upload the zip file to S3
aws s3 cp $ZIP_FILE s3://$S3_BUCKET/
EOT
  }

  # Ensure the S3 bucket exists before running the script
  depends_on = [aws_s3_bucket.source_files]
}
