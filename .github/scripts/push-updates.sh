#!/bin/bash
set -e

REPO="$1"
TAG="$2"

cd repo
git config user.name "GitHub Actions"
git config user.email "actions@github.com"
git add .
git commit -m "Update repo: $REPO@$TAG" || echo "No changes to commit"
git push