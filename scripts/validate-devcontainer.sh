#!/bin/bash

# DevContainer Validation Script
# This script validates the DevContainer configuration and setup

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

print_header "DevContainer Configuration Validation"

# Check if we're in a DevContainer
if [ -n "$REMOTE_CONTAINERS" ] || [ -n "$CODESPACES" ]; then
    print_success "Running in DevContainer environment"
else
    print_warning "Not running in DevContainer environment"
fi

# Check Node.js installation
print_step "Checking Node.js installation..."
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    print_success "Node.js installed: $NODE_VERSION"
    
    # Check if version is >= 20
    NODE_MAJOR=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')
    if [ "$NODE_MAJOR" -ge 20 ]; then
        print_success "Node.js version is compatible (>= 20)"
    else
        print_warning "Node.js version may be too old (current: $NODE_VERSION, recommended: >= 20)"
    fi
else
    print_error "Node.js not installed"
    exit 1
fi

# Check npm installation
print_step "Checking npm installation..."
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    print_success "npm installed: $NPM_VERSION"
else
    print_error "npm not installed"
    exit 1
fi

# Check TypeScript installation
print_step "Checking TypeScript installation..."
if command -v tsc &> /dev/null; then
    TSC_VERSION=$(tsc --version)
    print_success "TypeScript installed: $TSC_VERSION"
else
    print_warning "TypeScript not installed globally"
fi

# Check if TypeScript is available in project
if [ -f "node_modules/.bin/tsc" ]; then
    PROJECT_TSC_VERSION=$(./node_modules/.bin/tsc --version)
    print_success "TypeScript available in project: $PROJECT_TSC_VERSION"
else
    print_warning "TypeScript not found in project dependencies"
fi

# Check Office.js tools
print_step "Checking Office.js tools..."
OFFICE_TOOLS=(
    "office-addin-validator"
    "office-addin-dev-certs"
    "office-addin-debugging"
    "office-addin-lint"
    "office-addin-manifest"
)

for tool in "${OFFICE_TOOLS[@]}"; do
    if command -v "$tool" &> /dev/null; then
        print_success "$tool installed"
    else
        print_warning "$tool not installed globally"
    fi
done

# Check VS Code extensions (if in VS Code)
print_step "Checking VS Code extensions..."
if command -v code &> /dev/null; then
    print_status "VS Code CLI available, checking extensions..."
    
    # Check for key extensions
    KEY_EXTENSIONS=(
        "ms-vscode.vscode-typescript-next"
        "ms-vscode.vscode-office-addin-dev-tools"
        "esbenp.prettier-vscode"
        "ms-vscode.vscode-eslint"
    )
    
    for ext in "${KEY_EXTENSIONS[@]}"; do
        if code --list-extensions | grep -q "$ext"; then
            print_success "Extension installed: $ext"
        else
            print_warning "Extension not found: $ext"
        fi
    done
else
    print_warning "VS Code CLI not available"
fi

# Check port availability
print_step "Checking port availability..."
PORTS=(3000 8080 9229)

for port in "${PORTS[@]}"; do
    if netstat -tlnp 2>/dev/null | grep -q ":$port "; then
        print_warning "Port $port is already in use"
    else
        print_success "Port $port is available"
    fi
done

# Check configuration files
print_step "Checking configuration files..."

CONFIG_FILES=(
    "package.json"
    "tsconfig.json"
    "webpack.config.js"
    ".eslintrc.js"
    ".prettierrc"
    "jest.config.js"
)

for file in "${CONFIG_FILES[@]}"; do
    if [ -f "$file" ]; then
        print_success "Configuration file found: $file"
    else
        print_warning "Configuration file missing: $file"
    fi
done

# Check DevContainer configuration
print_step "Checking DevContainer configuration..."
if [ -f ".devcontainer/devcontainer.json" ]; then
    print_success "DevContainer configuration found"
    
    # Validate JSON syntax
    if python3 -m json.tool .devcontainer/devcontainer.json > /dev/null 2>&1; then
        print_success "DevContainer JSON syntax is valid"
    else
        print_error "DevContainer JSON syntax is invalid"
    fi
else
    print_error "DevContainer configuration missing"
fi

# Check Gitpod configuration
print_step "Checking Gitpod configuration..."
if [ -f ".gitpod.yml" ]; then
    print_success "Gitpod configuration found"
else
    print_warning "Gitpod configuration missing"
fi

# Check workspace structure
print_step "Checking workspace structure..."
WORKSPACE_DIRS=("projects" "templates" "examples" "docs" "scripts" "src")

for dir in "${WORKSPACE_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        print_success "Directory found: $dir"
    else
        print_warning "Directory missing: $dir"
    fi
done

# Check dependencies
print_step "Checking project dependencies..."
if [ -f "package.json" ]; then
    print_status "Installing dependencies..."
    if npm install; then
        print_success "Dependencies installed successfully"
    else
        print_error "Failed to install dependencies"
    fi
else
    print_warning "package.json not found"
fi

# Test build process
print_step "Testing build process..."
if [ -f "webpack.config.js" ] && [ -f "src/index.ts" ]; then
    print_status "Testing webpack build..."
    if npm run build:dev; then
        print_success "Build process working"
    else
        print_warning "Build process failed"
    fi
else
    print_warning "Build configuration or source files missing"
fi

# Test linting
print_step "Testing linting..."
if [ -f ".eslintrc.js" ] && [ -f "src/index.ts" ]; then
    print_status "Testing ESLint..."
    if npm run lint; then
        print_success "Linting working"
    else
        print_warning "Linting failed or found issues"
    fi
else
    print_warning "ESLint configuration or source files missing"
fi

# Test formatting
print_step "Testing formatting..."
if [ -f ".prettierrc" ] && [ -f "src/index.ts" ]; then
    print_status "Testing Prettier..."
    if npm run format; then
        print_success "Formatting working"
    else
        print_warning "Formatting failed"
    fi
else
    print_warning "Prettier configuration or source files missing"
fi

# Summary
print_header "Validation Summary"

if [ -n "$REMOTE_CONTAINERS" ] || [ -n "$CODESPACES" ]; then
    print_success "✅ DevContainer environment detected"
else
    print_warning "⚠️  Not running in DevContainer environment"
fi

print_status "Configuration validation complete!"
print_status "Check the output above for any warnings or errors."
print_status "All green checkmarks indicate proper configuration."

print_header "Next Steps"
echo "1. If running in DevContainer, test the development server:"
echo "   npm run dev-server"
echo ""
echo "2. If running in Gitpod, the environment should be ready automatically"
echo ""
echo "3. Check the troubleshooting guide: docs/DEVCONTAINER_TROUBLESHOOTING.md"
echo ""
echo "4. For issues, check the logs and configuration files"
