#!/bin/sh
set -exuo pipefail

export GO111MODULE=on

git config --global url."https://${GITHUB_TOKEN}:x-oauth-basic@github.com/".insteadOf "https://github.com"

WORK_SPACE=${PROJECT_PATH:-}

# Set PROJECT_PATH to change your working directory
if [ -z "${WORK_SPACE}" ]; then
  WORK_SPACE="."
fi

cd $WORK_SPACE
