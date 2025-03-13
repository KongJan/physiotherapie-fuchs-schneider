#!/bin/bash

# execute script with: BASH_ENV=./.env.local ./upload.sh

# Content of .env.local must be:
# AWS_ACCESS_KEY_ID="xxxxx"
# AWS_SECRET_ACCESS_KEY="xxxxx"
# AWS_DEFAULT_REGION="xxxxx"
# BUCKET_NAME="xxxxx"

# Export AWS credentials as environment variables
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null
then
    echo "AWS CLI could not be found. Please install it and try again."
    exit 1
fi

# Define an array of file paths to upload
FILES_TO_UPLOAD=(
    "./index.html"
    "./logo.png"
    "./favicon.ico"
    # Add more files as needed
)

# Iterate over the array of files and upload each one
for FILE_PATH in "${FILES_TO_UPLOAD[@]}"
do

  DESTINATION_PATH="s3://$BUCKET_NAME/$(basename "$FILE_PATH")"

  # Upload file to S3
  echo "Uploading $FILE_PATH to $DESTINATION_PATH..."
  aws s3 cp "$FILE_PATH" "$DESTINATION_PATH"

  if [ $? -eq 0 ]; then
      echo "File uploaded successfully."
  else
      echo "Failed to upload file."
      exit 1
  fi
done
