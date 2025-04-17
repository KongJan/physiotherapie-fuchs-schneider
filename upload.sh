#!/bin/bash

# execute script with: BASH_ENV=./.env.local ./upload.sh

# Content of .env.local must be:
# AWS_ACCESS_KEY_ID="xxxxx"
# AWS_SECRET_ACCESS_KEY="xxxxx"
# AWS_DEFAULT_REGION="xxxxx"
# BUCKET_NAME="xxxxx"
# DISTRIBUTION_ID="xxxxx"

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
  aws s3 cp "$FILE_PATH" "$DESTINATION_PATH"

  if [ $? -eq 0 ]; then
      printf "File uploaded successfully.\n\n"
  else
      printf "Failed to upload file.\n\n"
      exit 1
  fi
done

printf "Upload completed.\n\n"

aws cloudfront create-invalidation \
  --distribution-id $DISTRIBUTION_ID \
  --paths "/*"

printf "Invalidation completed.\n\n"
