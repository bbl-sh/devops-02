#!/bin/bash
FILE="storage_info.txt"

FILE_TO_UPLOAD="./index.html"

# check if the file exists or not, if not then throw error

if [[ ! -f "$FILE_TO_UPLOAD" ]]; then
  echo "File $FILE_TO_UPLOAD not found!"
  exit 1
fi

# Loop through the file
while IFS=' ' read -r STORAGE_ACCOUNT ACCESS_KEY
do
  if [[ -z "$STORAGE_ACCOUNT" || "$STORAGE_ACCOUNT" == \#* ]]; then
    continue
  fi

  echo "Uploading to storage account: $STORAGE_ACCOUNT..."

#upload the file to the $web container
  az storage blob upload \
      --account-name "$STORAGE_ACCOUNT" \
      --account-key "$ACCESS_KEY" \
      --container-name '$web' \
      --name "index.html" \
      --file "$FILE_TO_UPLOAD" \
      --content-type "text/html"

  if [ $? -eq 0 ]; then
    echo "File uploaded successfully to: https://$STORAGE_ACCOUNT.z22.web.core.windows.net/index.html"
  else
    echo "Failed to upload to $STORAGE_ACCOUNT"
  fi

done < "$FILE"
