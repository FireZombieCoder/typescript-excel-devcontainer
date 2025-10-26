#!/bin/bash

# Configure User Information Script
# This script updates all files to use FireZombieCoder and firezombify@gmail.com

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

print_header "Configure User Information"

# Set global git configuration
print_step "Setting global Git configuration..."
git config --global user.name "FireZombieCoder"
git config --global user.email "firezombify@gmail.com"
git config --global init.defaultBranch main
git config --global pull.rebase false
print_success "Global Git configuration updated"

# Update all package.json files
print_step "Updating package.json files..."
find . -name "package.json" -exec sed -i 's/"FireZombieCoder"/"FireZombieCoder"/g' {} \;
find . -name "package.json" -exec sed -i 's/"FireZombieCoder"/"FireZombieCoder"/g' {} \;
print_success "Package.json files updated"

# Update all shell scripts
print_step "Updating shell scripts..."
find . -name "*.sh" -exec sed -i 's/firezombify@gmail.com/firezombify@gmail.com/g' {} \;
find . -name "*.sh" -exec sed -i 's/firezombify@gmail.com/firezombify@gmail.com/g' {} \;
find . -name "*.sh" -exec sed -i 's/"FireZombieCoder"/"FireZombieCoder"/g' {} \;
find . -name "*.sh" -exec sed -i 's/"FireZombieCoder"/"FireZombieCoder"/g' {} \;
print_success "Shell scripts updated"

# Update all markdown files
print_step "Updating markdown files..."
find . -name "*.md" -exec sed -i 's/firezombify@gmail.com/firezombify@gmail.com/g' {} \;
find . -name "*.md" -exec sed -i 's/firezombify@gmail.com/firezombify@gmail.com/g' {} \;
find . -name "*.md" -exec sed -i 's/"FireZombieCoder"/"FireZombieCoder"/g' {} \;
find . -name "*.md" -exec sed -i 's/"FireZombieCoder"/"FireZombieCoder"/g' {} \;
print_success "Markdown files updated"

# Update all JSON files
print_step "Updating JSON files..."
find . -name "*.json" -exec sed -i 's/firezombify@gmail.com/firezombify@gmail.com/g' {} \;
find . -name "*.json" -exec sed -i 's/"FireZombieCoder"/"FireZombieCoder"/g' {} \;
find . -name "*.json" -exec sed -i 's/"FireZombieCoder"/"FireZombieCoder"/g' {} \;
print_success "JSON files updated"

# Update all YAML files
print_step "Updating YAML files..."
find . -name "*.yml" -exec sed -i 's/firezombify@gmail.com/firezombify@gmail.com/g' {} \;
find . -name "*.yaml" -exec sed -i 's/firezombify@gmail.com/firezombify@gmail.com/g' {} \;
find . -name "*.yml" -exec sed -i 's/"FireZombieCoder"/"FireZombieCoder"/g' {} \;
find . -name "*.yaml" -exec sed -i 's/"FireZombieCoder"/"FireZombieCoder"/g' {} \;
print_success "YAML files updated"

# Update Dockerfile files
print_step "Updating Dockerfile files..."
find . -name "Dockerfile*" -exec sed -i 's/firezombify@gmail.com/firezombify@gmail.com/g' {} \;
find . -name "Dockerfile*" -exec sed -i 's/"FireZombieCoder"/"FireZombieCoder"/g' {} \;
print_success "Dockerfile files updated"

# Update TypeScript files
print_step "Updating TypeScript files..."
find . -name "*.ts" -exec sed -i 's/firezombify@gmail.com/firezombify@gmail.com/g' {} \;
find . -name "*.ts" -exec sed -i 's/"FireZombieCoder"/"FireZombieCoder"/g' {} \;
print_success "TypeScript files updated"

# Update JavaScript files
print_step "Updating JavaScript files..."
find . -name "*.js" -exec sed -i 's/firezombify@gmail.com/firezombify@gmail.com/g' {} \;
find . -name "*.js" -exec sed -i 's/"FireZombieCoder"/"FireZombieCoder"/g' {} \;
print_success "JavaScript files updated"

# Update HTML files
print_step "Updating HTML files..."
find . -name "*.html" -exec sed -i 's/firezombify@gmail.com/firezombify@gmail.com/g' {} \;
find . -name "*.html" -exec sed -i 's/"FireZombieCoder"/"FireZombieCoder"/g' {} \;
print_success "HTML files updated"

# Verify changes
print_step "Verifying changes..."
echo "Git configuration:"
git config --global --list | grep user

echo ""
echo "Sample files updated:"
grep -r "FireZombieCoder" . --include="*.json" --include="*.yml" --include="*.sh" | head -5
grep -r "firezombify@gmail.com" . --include="*.json" --include="*.yml" --include="*.sh" | head -5

print_success "User information configuration completed!"

print_header "Configuration Summary"

echo "✅ Global Git Configuration:"
echo "   - Name: FireZombieCoder"
echo "   - Email: firezombify@gmail.com"
echo "   - Default branch: main"
echo "   - Pull rebase: false"
echo ""
echo "✅ Project Files Updated:"
echo "   - All package.json files"
echo "   - All shell scripts (*.sh)"
echo "   - All markdown files (*.md)"
echo "   - All JSON files (*.json)"
echo "   - All YAML files (*.yml, *.yaml)"
echo "   - All Dockerfile files"
echo "   - All TypeScript files (*.ts)"
echo "   - All JavaScript files (*.js)"
echo "   - All HTML files (*.html)"
echo ""
echo "🎯 Ready for development with FireZombieCoder identity!"
echo ""
echo "Next steps:"
echo "1. Commit the changes: git add . && git commit -m 'Configure user information'"
echo "2. Push to repository: git push origin main"
echo "3. Open in Gitpod: https://gitpod.io/#https://github.com/rdavidson1911/typescript-excel-devcontainer"
