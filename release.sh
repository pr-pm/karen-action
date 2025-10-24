#!/bin/bash
# Release script for karen-action
# Usage: ./release.sh <version> [release notes]
# Example: ./release.sh 1.0.7 "Bug fixes and improvements"
#
# This script will:
# 1. Create a tag for the specific version (e.g., v1.0.7)
# 2. Update the major version tag (e.g., v1) to point to the new version
# 3. Push both tags to remote
# 4. Create a GitHub release and set as latest

set -e

if [ -z "$1" ]; then
  echo "Error: Version number required"
  echo "Usage: ./release.sh <version> [release notes]"
  echo "Example: ./release.sh 1.0.7 \"Bug fixes and improvements\""
  exit 1
fi

VERSION=$1
RELEASE_NOTES="${2:-Release v$VERSION}"
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
read -p "Push tags and create GitHub release? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "Pushing tags..."
  git push origin "v$VERSION"
  git push origin "v$MAJOR_VERSION" --force
  echo "✓ Tags pushed"

  echo ""
  echo "Creating GitHub release..."

  # Check if gh CLI is installed
  if ! command -v gh &> /dev/null; then
    echo "⚠️  GitHub CLI (gh) not found. Skipping release creation."
    echo "Install it with: brew install gh"
    echo "Or create release manually at: https://github.com/khaliqgant/karen-action/releases/new"
  else
    # Create release with gh CLI
    gh release create "v$VERSION" \
      --title "v$VERSION" \
      --notes "$RELEASE_NOTES" \
      --latest

    echo "✓ GitHub release created and set as latest"
  fi

  echo ""
  echo "✅ Release complete!"
  echo ""
  echo "Users can now use:"
  echo "  uses: khaliqgant/karen-action@v$VERSION"
  echo "  uses: khaliqgant/karen-action@v$MAJOR_VERSION  (auto-updates)"
else
  echo ""
  echo "Tags created locally but not pushed."
  echo "To push and release later, run:"
  echo "  git push origin v$VERSION"
  echo "  git push origin v$MAJOR_VERSION --force"
  echo "  gh release create v$VERSION --title \"v$VERSION\" --notes \"$RELEASE_NOTES\" --latest"
fi
