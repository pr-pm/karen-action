#!/bin/bash
# Release script for karen-action
# Usage: ./release.sh <version>
# Example: ./release.sh 1.0.7
#
# This script will:
# 1. Create a tag for the specific version (e.g., v1.0.7)
# 2. Update the major version tag (e.g., v1) to point to the new version
# 3. Push both tags to remote

set -e

if [ -z "$1" ]; then
  echo "Error: Version number required"
  echo "Usage: ./release.sh <version>"
  echo "Example: ./release.sh 1.0.7"
  exit 1
fi

VERSION=$1
MAJOR_VERSION=$(echo $VERSION | cut -d. -f1)

echo "📦 Releasing version $VERSION"
echo ""

# Check if version already exists
if git rev-parse "v$VERSION" >/dev/null 2>&1; then
  echo "⚠️  Tag v$VERSION already exists"
  read -p "Delete and recreate? (y/n) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    git tag -d "v$VERSION"
    echo "✓ Deleted local tag v$VERSION"
  else
    echo "Aborted"
    exit 1
  fi
fi

# Create version tag
echo "Creating tag v$VERSION..."
git tag "v$VERSION"
echo "✓ Created tag v$VERSION"

# Update major version tag
echo "Updating tag v$MAJOR_VERSION to point to v$VERSION..."
if git rev-parse "v$MAJOR_VERSION" >/dev/null 2>&1; then
  git tag -d "v$MAJOR_VERSION"
  echo "✓ Deleted old v$MAJOR_VERSION tag"
fi
git tag "v$MAJOR_VERSION" "v$VERSION"
echo "✓ Created v$MAJOR_VERSION -> v$VERSION"

echo ""
echo "📋 Summary:"
echo "  v$VERSION       → $(git rev-parse --short v$VERSION)"
echo "  v$MAJOR_VERSION → $(git rev-parse --short v$MAJOR_VERSION)"
echo ""

# Push tags
read -p "Push tags to remote? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Pushing tags..."
  git push origin "v$VERSION"
  git push origin "v$MAJOR_VERSION" --force
  echo ""
  echo "✅ Release complete!"
  echo ""
  echo "Users can now use:"
  echo "  uses: khaliqgant/karen-action@v$VERSION"
  echo "  uses: khaliqgant/karen-action@v$MAJOR_VERSION  (auto-updates)"
else
  echo ""
  echo "Tags created locally but not pushed."
  echo "To push later, run:"
  echo "  git push origin v$VERSION"
  echo "  git push origin v$MAJOR_VERSION --force"
fi
