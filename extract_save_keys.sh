#!/bin/bash

STORAGE_URL_FILE="storage_url.txt"

OUTPUT_FILE="storage_info.txt"

RESOURCE_GROUP="rg-dev"

# Ensure the output file is empty before starting
> "$OUTPUT_FILE"

while IFS= read -r LINE
do

  STORAGE_ACCOUNT=$(echo "$LINE" | awk -F'[/.]' '{print $3}')

  if [[ -z "$STORAGE_ACCOUNT" ]]; then
    continue
  fi

  echo "Processing storage account: $STORAGE_ACCOUNT..."

  KEYS=$(az storage account keys list --resource-group "$RESOURCE_GROUP" --account-name "$STORAGE_ACCOUNT" --query '[0].value' -o tsv)

  if [[ -n "$KEYS" ]]; then
    echo "$STORAGE_ACCOUNT $KEYS" >> "$OUTPUT_FILE"
    echo "Stored: $STORAGE_ACCOUNT with its access key."
  else
    echo "Error: Could not retrieve keys for $STORAGE_ACCOUNT."
  fi

done < "$STORAGE_URL_FILE"

echo "All storage accounts processed. Output saved to $OUTPUT_FILE."
