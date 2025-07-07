#!/bin/bash
set -e

REPO="$1"
TAG="$2"

mkdir -p pkg

echo "⬇️ Downloading packages from $REPO@$TAG..."
gh release download "$TAG" \
  --repo "$REPO" \
  --pattern "*.pkg.tar.zst" \
  --dir pkg

count=$(ls pkg/*.pkg.tar.zst | wc -l)
if [ "$count" -eq 0 ]; then
  echo "❌ No .pkg.tar.zst file found in release."
  exit 1
fi
