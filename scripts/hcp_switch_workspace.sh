#!/bin/bash

WORKSPACE_NAME=$1
TFC_TOKEN=$2

# Fetch workspace ID
WORKSPACE_ID=$(curl --silent \
    --header "Authorization: Bearer $TFC_TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    "https://app.terraform.io/api/v2/organizations/amora-hc/workspaces" \
    | jq -r ".data[] | select(.attributes.name==\"$WORKSPACE_NAME\") | .id")

if [ -z "$WORKSPACE_ID" ]; then
  echo "Workspace $WORKSPACE_NAME does not exist, skipping."
  exit 0
fi

# Switch execution mode to local
curl --silent \
    --header "Authorization: Bearer $TFC_TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    --request PATCH \
    --data '{
        "data": {
            "type": "workspaces",
            "attributes": {
                "execution-mode": "local"
            }
        }
    }' \
    "https://app.terraform.io/api/v2/workspaces/${WORKSPACE_ID}" > /dev/null

echo "Switched workspace $WORKSPACE_NAME to local mode."