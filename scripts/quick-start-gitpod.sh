#!/bin/bash

# Quick Start Script for Gitpod
# This script provides a quick way to get started with Gitpod for TypeScript Excel development

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

print_header "TypeScript Excel Development - Gitpod Quick Start"

echo "🚀 Welcome to the TypeScript Excel Development Environment!"
echo "This script will help you get started with Gitpod for Office Add-in development."
echo ""

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    print_warning "Not in a git repository. Initializing git..."
    git init
    git add .
    git commit -m "Initial commit: TypeScript Excel Development Environment"
fi

# Check if Gitpod is already configured
if [ -f ".gitpod.yml" ]; then
    print_success "Gitpod is already configured!"
    print_status "You can now:"
    print_status "1. Push to GitHub: git push origin main"
    print_status "2. Open in Gitpod: https://gitpod.io"
    print_status "3. Start developing!"
    exit 0
fi

# Run the setup script
print_step "Setting up Gitpod configuration..."
if [ -f "scripts/setup-gitpod-windows.sh" ]; then
    ./scripts/setup-gitpod-windows.sh
else
    print_error "Gitpod setup script not found!"
    print_status "Please ensure you're in the correct directory."
    exit 1
fi

print_header "Next Steps"

echo "🎉 Gitpod setup complete! Here's what to do next:"
echo ""
echo "1. 📝 Commit your changes:"
echo "   git add ."
echo "   git commit -m 'Add Gitpod configuration'"
echo ""
echo "2. 🚀 Push to GitHub:"
echo "   git push origin main"
echo ""
echo "3. 🌐 Open in Gitpod:"
echo "   - Go to https://gitpod.io"
echo "   - Sign in with your GitHub account"
echo "   - Open your repository"
echo "   - Wait for the workspace to initialize"
echo ""
echo "4. 🛠️ Start developing:"
echo "   - The workspace will automatically set up"
echo "   - Run 'npm run dev-server' to start development"
echo "   - Your app will be available at the preview URL"
echo ""
echo "5. 📚 Read the documentation:"
echo "   - Check docs/gitpod-setup-guide.md"
echo "   - Review the Office.js documentation"
echo ""
echo "🔗 Useful links:"
echo "   - Gitpod: https://gitpod.io"
echo "   - Office.js: https://docs.microsoft.com/en-us/office/dev/add-ins/"
echo "   - TypeScript: https://www.typescriptlang.org/"
echo ""
echo "Happy coding! 🚀"
