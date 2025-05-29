#!/usr/bin/env bash

LOG_FILE=${LOG_FILE:-"init.log"}

set -e
exec > >(tee $LOG_FILE) 2>&1

PROJECT=${PROJECT:-"wordlist"}

if [ -z "$ENVIRONMENT" ]; then
    echo "Please set ENVIRONMENT first"
    exit 1
fi

BUCKET_NAME="$PROJECT-$ENVIRONMENT-infrastructure-state"
REGION=${REGION:-"eu-west-2"}

echo "Using configuration: "
echo "  Log File:    $LOG_FILE"
echo "  Project:     $PROJECT"
echo "  Environment: $ENVIRONMENT"

echo "Checking for a bucket named $BUCKET_NAME ..."
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
    echo "State bucket already exists!"
else
    echo "Started creating bucket $BUCKET_NAME ..."

    if ! aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$REGION" --create-bucket-configuration LocationConstraint="$REGION"; then
        echo "Failed to create bucket"
        exit 1
    fi

    if ! aws s3api put-bucket-versioning --bucket "$BUCKET_NAME" --versioning-configuration Status=Enabled; then 
        echo "WARNING: Failed to set versioning on bucket"
    fi

    echo "Finished creating $BUCKET_NAME"
fi

echo "Started writing backend configuration file..."
# Generate Terraform backend configuration
cat <<EOF > backend.tf
terraform {
  backend "s3" {
    bucket         = "$BUCKET_NAME"
    key            = "terraform/state.tfstate"
    region         = "$REGION"
    encrypt        = true
  }
}
EOF

echo "Formatting backend configuration file..."
terraform fmt backend.tf

# Print confirmation
echo "Finished writing backend configuration file"

echo "Initialising terraform..."
terraform init