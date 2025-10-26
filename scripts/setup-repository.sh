#!/bin/bash

# Repository Setup Script
# This script helps set up your own repository and update all URLs

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${PURPLE}================================${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${PURPLE}================================${NC}"
}

print_step() {
    echo -e "${CYAN}[STEP]${NC} $1"
}

print_header "Repository Setup for FireZombieCoder"

# Get current git user
CURRENT_USER=$(git config --global user.name)
CURRENT_EMAIL=$(git config --global user.email)

echo "Current Git Configuration:"
echo "  Username: $CURRENT_USER"
echo "  Email: $CURRENT_EMAIL"
echo ""

# Determine the correct repository URL
print_step "Setting up repository URL..."

# Check if we're authenticated as rdavidson1911
if git config --global user.name | grep -q "rdavidson1911"; then
    REPO_URL="https://github.com/rdavidson1911/typescript-excel-devcontainer.git"
    GITHUB_USER="rdavidson1911"
    print_warning "Detected rdavidson1911 as the authenticated user"
    print_status "Will use: $REPO_URL"
elif git config --global user.name | grep -q "FireZombieCoder"; then
    REPO_URL="https://github.com/rdavidson1911/typescript-excel-devcontainer.git"
    GITHUB_USER="FireZombieCoder"
    print_status "Using FireZombieCoder repository"
else
    print_error "Unable to determine the correct repository URL"
    print_status "Please create a repository on GitHub and provide the URL"
    exit 1
fi

# Add the remote repository
print_step "Adding remote repository..."
git remote add origin "$REPO_URL"
print_success "Remote repository added: $REPO_URL"

# Update all files with the correct repository URL
print_step "Updating repository URLs in all files..."

# Update package.json files
find . -name "package.json" -exec sed -i "s|github.com/rdavidson1911/typescript-excel-devcontainer|github.com/$GITHUB_USER/typescript-excel-devcontainer|g" {} \;

# Update shell scripts
find . -name "*.sh" -exec sed -i "s|github.com/rdavidson1911/typescript-excel-devcontainer|github.com/$GITHUB_USER/typescript-excel-devcontainer|g" {} \;

# Update markdown files
find . -name "*.md" -exec sed -i "s|github.com/rdavidson1911/typescript-excel-devcontainer|github.com/$GITHUB_USER/typescript-excel-devcontainer|g" {} \;

# Update YAML files
find . -name "*.yml" -exec sed -i "s|github.com/rdavidson1911/typescript-excel-devcontainer|github.com/$GITHUB_USER/typescript-excel-devcontainer|g" {} \;
find . -name "*.yaml" -exec sed -i "s|github.com/rdavidson1911/typescript-excel-devcontainer|github.com/$GITHUB_USER/typescript-excel-devcontainer|g" {} \;

print_success "Repository URLs updated in all files"

# Show the updated configuration
print_step "Updated Configuration:"
echo "  Repository URL: $REPO_URL"
echo "  GitHub User: $GITHUB_USER"
echo "  Git Username: $CURRENT_USER"
echo "  Git Email: $CURRENT_EMAIL"

# Show next steps
print_header "Next Steps"

echo "🎯 To complete the setup:"
echo ""
echo "1. 📝 Create the repository on GitHub:"
echo "   - Go to https://github.com/new"
echo "   - Repository name: typescript-excel-devcontainer"
echo "   - Description: TypeScript Excel Development Environment with Gitpod Support"
echo "   - Make it Public (required for free Gitpod usage)"
echo "   - Don't initialize with README (we already have one)"
echo "   - Click 'Create repository'"
echo ""
echo "2. 🚀 Push your code:"
echo "   git add ."
echo "   git commit -m 'Update repository URLs for $GITHUB_USER'"
echo "   git push -u origin main"
echo ""
echo "3. 🌐 Open in Gitpod:"
echo "   https://gitpod.io/#$REPO_URL"
echo ""
echo "4. 🛠️ Start developing:"
echo "   - The workspace will automatically set up"
echo "   - Run 'npm run dev-server' to start development"
echo "   - Your app will be available at the preview URL"
echo ""

# Check if repository exists
print_step "Checking if repository exists..."
if curl -s --head "https://github.com/$GITHUB_USER/typescript-excel-devcontainer" | head -n 1 | grep -q "200 OK"; then
    print_success "Repository exists and is accessible!"
    print_status "You can now push your code:"
    echo "  git add ."
    echo "  git commit -m 'Update repository URLs'"
    echo "  git push -u origin main"
else
    print_warning "Repository doesn't exist yet or is not accessible"
    print_status "Please create it on GitHub first, then run:"
    echo "  git add ."
    echo "  git commit -m 'Update repository URLs'"
    echo "  git push -u origin main"
fi

print_success "Repository setup configuration completed!"
