#!/bin/bash

# Repository Cleanup Script for Publishing
# This script cleans up the repository before publishing to GitHub

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

print_header "Repository Cleanup for Publishing"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    print_error "Not in a git repository. Please run this script from the repository root."
    exit 1
fi

# Step 1: Remove temporary and cache files
print_step "Removing temporary and cache files..."

# Remove common temporary files
find . -name "*.log" -type f -delete 2>/dev/null || true
find . -name "*.tmp" -type f -delete 2>/dev/null || true
find . -name "*.cache" -type f -delete 2>/dev/null || true
find . -name ".DS_Store" -type f -delete 2>/dev/null || true
find . -name "Thumbs.db" -type f -delete 2>/dev/null || true
find . -name "*.swp" -type f -delete 2>/dev/null || true
find . -name "*.swo" -type f -delete 2>/dev/null || true
find . -name "*~" -type f -delete 2>/dev/null || true

# Remove node_modules if they exist (they should be in .gitignore)
if [ -d "node_modules" ]; then
    print_warning "Removing node_modules directory"
    rm -rf node_modules
fi

# Remove dist directories
find . -name "dist" -type d -exec rm -rf {} + 2>/dev/null || true
find . -name "build" -type d -exec rm -rf {} + 2>/dev/null || true
find . -name "coverage" -type d -exec rm -rf {} + 2>/dev/null || true

print_success "Temporary files removed"

# Step 2: Check for secrets and sensitive information
print_step "Checking for secrets and sensitive information..."

# Check for common secret patterns
SECRET_PATTERNS=(
    "password"
    "secret"
    "key"
    "token"
    "api_key"
    "apikey"
    "access_key"
    "secret_key"
    "private_key"
    "auth_token"
    "bearer_token"
    "jwt"
    "credential"
    "aws_access_key"
    "aws_secret_key"
    "github_token"
    "gitlab_token"
    "bitbucket_token"
    "npm_token"
    "dockerhub_token"
    "azure_key"
    "google_key"
    "firebase_key"
)

SECRETS_FOUND=false

for pattern in "${SECRET_PATTERNS[@]}"; do
    if grep -r -i "$pattern" . --exclude-dir=.git --exclude-dir=node_modules --exclude="*.md" --exclude="cleanup-for-publish.sh" | grep -v "example\|placeholder\|template\|your-" >/dev/null 2>&1; then
        print_warning "Potential secret pattern found: $pattern"
        SECRETS_FOUND=true
    fi
done

if [ "$SECRETS_FOUND" = false ]; then
    print_success "No secrets or sensitive information found"
else
    print_warning "Please review the potential secrets found above"
fi

# Step 3: Check for personal information
print_step "Checking for personal information..."

# Check for email addresses (excluding example.com)
if grep -r -E "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b" . --exclude-dir=.git --exclude-dir=node_modules | grep -v "example.com\|gitpod@example.com" >/dev/null 2>&1; then
    print_warning "Personal email addresses found. Please review:"
    grep -r -E "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b" . --exclude-dir=.git --exclude-dir=node_modules | grep -v "example.com\|gitpod@example.com" || true
else
    print_success "No personal email addresses found"
fi

# Check for personal names (excluding common placeholders)
if grep -r -i "author.*:" . --exclude-dir=.git --exclude-dir=node_modules | grep -v "Your Name\|FireZombieCoder\|gitpod" >/dev/null 2>&1; then
    print_warning "Personal names found. Please review:"
    grep -r -i "author.*:" . --exclude-dir=.git --exclude-dir=node_modules | grep -v "Your Name\|FireZombieCoder\|gitpod" || true
else
    print_success "No personal names found"
fi

# Step 4: Update placeholder information
print_step "Updating placeholder information..."

# Update repository URLs in package.json files
find . -name "package.json" -exec sed -i 's|FireZombieCoder|FireZombieCoder|g' {} \;
find . -name "package.json" -exec sed -i 's|typescript-excel-devcontainer|typescript-excel-devcontainer|g' {} \;

# Update repository URLs in scripts
find . -name "*.sh" -exec sed -i 's|FireZombieCoder|FireZombieCoder|g' {} \;
find . -name "*.sh" -exec sed -i 's|typescript-excel-devcontainer|typescript-excel-devcontainer|g' {} \;

# Update author information
find . -name "package.json" -exec sed -i 's|"Your Name"|"FireZombieCoder"|g' {} \;

print_success "Placeholder information updated"

# Step 5: Clean up .gitignore
print_step "Ensuring .gitignore is comprehensive..."

# Check if .gitignore exists
if [ ! -f ".gitignore" ]; then
    print_warning ".gitignore not found, creating one"
    cat > .gitignore << 'EOF'
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Build outputs
dist/
build/
coverage/

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# IDE files
.vscode/
.idea/
*.swp
*.swo
*~

# OS files
.DS_Store
Thumbs.db

# Logs
*.log
logs/

# Runtime data
pids/
*.pid
*.seed
*.pid.lock

# Optional npm cache directory
.npm

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity

# dotenv environment variables file
.env

# parcel-bundler cache (https://parceljs.org/)
.cache
.parcel-cache

# next.js build output
.next

# nuxt.js build output
.nuxt

# vuepress build output
.vuepress/dist

# Serverless directories
.serverless

# FuseBox cache
.fusebox/

# DynamoDB Local files
.dynamodb/

# TernJS port file
.tern-port

# Stores VSCode versions used for testing VSCode extensions
.vscode-test

# Office Add-in specific
manifest.xml
*.pfx
*.p12
*.cer
*.crt
*.key
*.pem

# Gitpod specific
.gitpod/
EOF
    print_success ".gitignore created"
else
    print_success ".gitignore already exists"
fi

# Step 6: Remove unnecessary files
print_step "Removing unnecessary files..."

# Remove task files (these are typically for development tracking)
if [ -d ".tasks" ]; then
    print_warning "Removing .tasks directory"
    rm -rf .tasks
fi

# Remove any backup files
find . -name "*.backup" -type f -delete 2>/dev/null || true
find . -name "*.bak" -type f -delete 2>/dev/null || true

print_success "Unnecessary files removed"

# Step 7: Verify git status
print_step "Checking git status..."

git status --porcelain

if [ -z "$(git status --porcelain)" ]; then
    print_success "Working directory is clean"
else
    print_warning "There are uncommitted changes. Please review:"
    git status
fi

# Step 8: Create a pre-publish checklist
print_step "Creating pre-publish checklist..."

cat > PRE_PUBLISH_CHECKLIST.md << 'EOF'
# Pre-Publish Checklist

## ✅ Security Check
- [ ] No secrets, API keys, or passwords in code
- [ ] No personal email addresses (except example.com)
- [ ] No personal names (except FireZombieCoder)
- [ ] No sensitive configuration files

## ✅ File Cleanup
- [ ] No temporary files (*.log, *.tmp, *.cache)
- [ ] No OS-specific files (.DS_Store, Thumbs.db)
- [ ] No IDE-specific files (.vscode/, .idea/)
- [ ] No node_modules or dist directories
- [ ] No backup files (*.backup, *.bak)

## ✅ Repository Information
- [ ] All placeholder URLs updated to FireZombieCoder/typescript-excel-devcontainer
- [ ] Author information updated
- [ ] Repository URLs are correct
- [ ] No broken links

## ✅ Documentation
- [ ] README.md is up to date
- [ ] All documentation files are present
- [ ] No TODO comments in production code
- [ ] All scripts are executable

## ✅ Git Status
- [ ] Working directory is clean
- [ ] All changes are committed
- [ ] Remote repository is configured
- [ ] Ready to push

## ✅ Final Verification
- [ ] Test the setup script locally
- [ ] Verify all configuration files
- [ ] Check that Gitpod configuration works
- [ ] Ensure all examples and templates work

## 🚀 Ready to Publish
Once all items are checked, you can safely publish to GitHub:

```bash
git add .
git commit -m "Clean up repository for publishing"
git push -u origin main
```

Then open in Gitpod:
https://gitpod.io/#https://github.com/FireZombieCoder/typescript-excel-devcontainer
EOF

print_success "Pre-publish checklist created: PRE_PUBLISH_CHECKLIST.md"

# Step 9: Summary
print_header "Cleanup Summary"

echo "🎉 Repository cleanup completed!"
echo ""
echo "📋 Next steps:"
echo "1. Review the PRE_PUBLISH_CHECKLIST.md file"
echo "2. Check all items in the checklist"
echo "3. Test the setup script: ./scripts/setup-gitpod-windows.sh --test"
echo "4. Commit any remaining changes"
echo "5. Push to GitHub: git push -u origin main"
echo "6. Open in Gitpod: https://gitpod.io/#https://github.com/FireZombieCoder/typescript-excel-devcontainer"
echo ""
echo "🔗 Repository URL: https://github.com/FireZombieCoder/typescript-excel-devcontainer"
echo ""
echo "Happy coding! 🚀"
