#!/bin/sh

if [ -z "$COLLECTION_NAMESPACE" ] || [ -z "$COLLECTION_NAME" ] || [ -z "$COLLECTION_VERSION" ]; then
  echo "ERROR - The required variables (COLLECTION_NAMESPACE, COLLECTION_NAME, COLLECTION_VERSION) are not set!"
  exit 1
fi

# Create Git tag
git tag "v$COLLECTION_VERSION"

# Build collection archive
ansible-galaxy collection build -c

# Publish archive to Galaxy
ansible-galaxy collection publish -c -vvv "./$COLLECTION_NAMESPACE-$COLLECTION_NAME-$COLLECTION_VERSION.tar.gz"
