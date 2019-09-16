#!/bin/bash

set -exuo pipefail

EVENT_DATA=$(cat $GITHUB_EVENT_PATH)
UPLOAD_URL=$(echo $EVENT_DATA | jq -r .release.upload_url)
UPLOAD_URL=${UPLOAD_URL/\{?name,label\}/}
PROJECT_NAME=$(basename $GITHUB_REPOSITORY)
NAME="${PROJECT_NAME}-${GOOS}-${GOARCH}"

echo "Building $NAME under $GOOS/$GOARCH"
go build -o "$NAME"

curl \
  --fail \
  -X POST \
  --data-binary @${NAME}\
  -H 'Content-Type: application/octet-stream' \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  "${UPLOAD_URL}?name=${NAME}"

CHECKSUM=$(md5sum "$NAME" | cut -d ' ' -f 1)

curl \
  -X POST \
  --data "$CHECKSUM" \
  -H 'Content-Type: text/plain' \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  "${UPLOAD_URL}?name=${NAME}_checksum.txt"