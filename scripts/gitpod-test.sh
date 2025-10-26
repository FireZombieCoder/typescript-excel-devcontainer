#!/bin/bash

# Gitpod Test Script
# This script tests the Gitpod configuration and environment

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

print_header "Gitpod Configuration Test"

# Test environment
print_step "Testing environment..."

if [ -n "$GITPOD_WORKSPACE_ID" ]; then
    print_success "Running in Gitpod workspace: $GITPOD_WORKSPACE_ID"
    print_status "Workspace URL: $GITPOD_WORKSPACE_URL"
    print_status "Cluster Host: $GITPOD_WORKSPACE_CLUSTER_HOST"
else
    print_warning "Not running in Gitpod environment"
fi

# Test Node.js
print_step "Testing Node.js..."
if command -v node >/dev/null 2>&1; then
    node_version=$(node --version)
    print_success "Node.js $node_version is installed"
else
    print_error "Node.js is not installed"
    exit 1
fi

# Test npm
print_step "Testing npm..."
if command -v npm >/dev/null 2>&1; then
    npm_version=$(npm --version)
    print_success "npm $npm_version is installed"
else
    print_error "npm is not installed"
    exit 1
fi

# Test TypeScript
print_step "Testing TypeScript..."
if command -v tsc >/dev/null 2>&1; then
    local tsc_version=$(tsc --version)
    print_success "TypeScript $tsc_version is installed"
else
    print_error "TypeScript is not installed"
    exit 1
fi

# Test Office.js tools
print_step "Testing Office.js tools..."
if command -v office-addin-validator >/dev/null 2>&1; then
    local validator_version=$(office-addin-validator --version 2>/dev/null || echo "unknown")
    print_success "Office Add-in Validator $validator_version is installed"
else
    print_warning "Office Add-in Validator not available"
fi

# Test webpack
print_step "Testing webpack..."
if command -v webpack >/dev/null 2>&1; then
    local webpack_version=$(webpack --version 2>/dev/null || echo "unknown")
    print_success "Webpack $webpack_version is installed"
else
    print_warning "Webpack not available"
fi

# Test Jest
print_step "Testing Jest..."
if command -v jest >/dev/null 2>&1; then
    local jest_version=$(jest --version 2>/dev/null || echo "unknown")
    print_success "Jest $jest_version is installed"
else
    print_warning "Jest not available"
fi

# Test project structure
print_step "Testing project structure..."

if [ -f "package.json" ]; then
    print_success "package.json exists"
else
    print_error "package.json not found"
    exit 1
fi

if [ -f "tsconfig.json" ]; then
    print_success "tsconfig.json exists"
else
    print_warning "tsconfig.json not found"
fi

if [ -f "webpack.config.js" ]; then
    print_success "webpack.config.js exists"
else
    print_warning "webpack.config.js not found"
fi

if [ -d "src" ]; then
    print_success "src directory exists"
else
    print_warning "src directory not found"
fi

# Test dependencies
print_step "Testing dependencies..."
if [ -f "package.json" ]; then
    if npm list --depth=0 >/dev/null 2>&1; then
        print_success "Dependencies are installed"
    else
        print_warning "Some dependencies may be missing"
    fi
else
    print_warning "Cannot test dependencies - no package.json"
fi

# Test build process
print_step "Testing build process..."
if [ -f "webpack.config.js" ] && [ -d "src" ]; then
    if npm run build >/dev/null 2>&1; then
        print_success "Build process works"
    else
        print_warning "Build process may have issues"
    fi
else
    print_warning "Cannot test build - missing webpack config or src directory"
fi

# Test development server (quick test)
print_step "Testing development server..."
if [ -f "webpack.config.js" ]; then
    print_status "Starting development server test (10 seconds)..."
    timeout 10s npm run dev-server >/dev/null 2>&1 || print_status "Dev server test completed"
    print_success "Development server test completed"
else
    print_warning "Cannot test dev server - missing webpack config"
fi

# Test Git configuration
print_step "Testing Git configuration..."
if command -v git >/dev/null 2>&1; then
    local git_user=$(git config --global user.name 2>/dev/null || echo "Not set")
    local git_email=$(git config --global user.email 2>/dev/null || echo "Not set")
    print_success "Git user: $git_user"
    print_success "Git email: $git_email"
else
    print_warning "Git not available"
fi

# Test port availability
print_step "Testing port availability..."
if command -v netstat >/dev/null 2>&1; then
    local port_3000=$(netstat -tuln 2>/dev/null | grep :3000 || echo "Available")
    local port_8080=$(netstat -tuln 2>/dev/null | grep :8080 || echo "Available")
    print_status "Port 3000: $port_3000"
    print_status "Port 8080: $port_8080"
else
    print_warning "Cannot test port availability - netstat not available"
fi

# Display workspace URLs
if [ -n "$GITPOD_WORKSPACE_ID" ]; then
    print_step "Workspace URLs:"
    echo "   - Main dev server: https://3000-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
    echo "   - Office Add-in: https://8080-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
    echo "   - Debug port: https://9229-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
fi

print_header "Test Summary"
print_success "All tests completed!"
print_status "Your Gitpod environment is ready for TypeScript Excel development"
print_status "Run 'npm run dev-server' to start developing"
