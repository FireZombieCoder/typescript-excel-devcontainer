#!/bin/bash

# Gitpod Workspace Setup Script
# This script helps you set up and configure Gitpod for TypeScript Excel development

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

print_header "Gitpod Workspace Setup for TypeScript Excel Development"

# Repository information
REPO_URL="https://github.com/FireZombieCoder/typescript-excel-devcontainer"
GITPOD_URL="https://gitpod.io/#$REPO_URL"

echo "🚀 Setting up Gitpod workspace for TypeScript Excel development"
echo ""
echo "📋 Repository Information:"
echo "   Repository: $REPO_URL"
echo "   Gitpod URL: $GITPOD_URL"
echo ""

# Check if we're already in Gitpod
if [ -n "$GITPOD_WORKSPACE_ID" ]; then
    print_success "Already running in Gitpod workspace: $GITPOD_WORKSPACE_ID"
    print_status "Running workspace setup..."
    ./scripts/gitpod-setup.sh
    exit 0
fi

# Check prerequisites
print_step "Checking prerequisites..."

# Check if curl is available
if ! command -v curl >/dev/null 2>&1; then
    print_error "curl is not installed. Please install curl first."
    exit 1
fi

# Check if git is available
if ! command -v git >/dev/null 2>&1; then
    print_error "Git is not installed. Please install Git first."
    exit 1
fi

# Check internet connectivity
print_step "Checking internet connectivity..."
if curl -s --connect-timeout 10 https://gitpod.io >/dev/null 2>&1; then
    print_success "Gitpod.io is accessible"
else
    print_error "Cannot reach Gitpod.io. Please check your internet connection."
    exit 1
fi

if curl -s --connect-timeout 10 https://github.com >/dev/null 2>&1; then
    print_success "GitHub is accessible"
else
    print_warning "Cannot reach GitHub"
fi

print_success "Prerequisites check passed"

# Verify Gitpod configuration files
print_step "Verifying Gitpod configuration..."

if [ -f ".gitpod.yml" ]; then
    print_success ".gitpod.yml exists"
else
    print_error ".gitpod.yml not found"
    exit 1
fi

if [ -f ".gitpod.Dockerfile" ]; then
    print_success ".gitpod.Dockerfile exists"
else
    print_error ".gitpod.Dockerfile not found"
    exit 1
fi

# Check if repository is pushed
print_step "Checking repository status..."
if git remote get-url origin >/dev/null 2>&1; then
    REMOTE_URL=$(git remote get-url origin)
    print_success "Remote repository configured: $REMOTE_URL"
else
    print_error "No remote repository configured"
    exit 1
fi

# Test the setup script
print_step "Testing setup script..."
if [ -f "scripts/gitpod-setup.sh" ]; then
    print_success "Gitpod setup script exists"
else
    print_error "Gitpod setup script not found"
    exit 1
fi

print_header "Gitpod Workspace Setup Complete!"

echo "🎉 Your TypeScript Excel development environment is ready for Gitpod!"
echo ""
echo "📋 What's configured:"
echo "   ✅ Gitpod configuration files (.gitpod.yml, .gitpod.Dockerfile)"
echo "   ✅ TypeScript Excel development environment"
echo "   ✅ Office.js SDK and tools"
echo "   ✅ VS Code extensions for Office development"
echo "   ✅ Project templates and examples"
echo "   ✅ Automated setup scripts"
echo ""
echo "🚀 Next Steps:"
echo ""
echo "1. 🌐 Open in Gitpod:"
echo "   Click this link to open your workspace:"
echo "   $GITPOD_URL"
echo ""
echo "2. 🛠️ Alternative - Manual Gitpod Setup:"
echo "   - Go to https://gitpod.io"
echo "   - Sign in with your GitHub account"
echo "   - Click 'New Workspace'"
echo "   - Enter: $REPO_URL"
echo "   - Click 'Create Workspace'"
echo ""
echo "3. 🎯 Start Developing:"
echo "   - The workspace will automatically set up"
echo "   - Run 'npm run dev-server' to start development"
echo "   - Your app will be available at the preview URL"
echo ""
echo "4. 📚 Available Commands in Gitpod:"
echo "   - npm run dev-server    # Start development server"
echo "   - npm run build         # Build for production"
echo "   - npm test              # Run tests"
echo "   - npm run lint          # Run ESLint"
echo "   - ./scripts/setup-project.sh my-addin  # Create new project"
echo ""
echo "🔗 Useful Links:"
echo "   - Gitpod: https://gitpod.io"
echo "   - Your Repository: $REPO_URL"
echo "   - Office.js Documentation: https://docs.microsoft.com/en-us/office/dev/add-ins/"
echo "   - TypeScript Handbook: https://www.typescriptlang.org/docs/"
echo ""
echo "Happy coding with TypeScript and Excel! 🚀"
