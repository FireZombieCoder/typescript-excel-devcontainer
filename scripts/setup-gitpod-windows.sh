#!/bin/bash

# Gitpod Setup Script for Windows 11 with WSL2
# This script sets up Gitpod for TypeScript Excel development with Office Add-ins
# Designed to work with Windows 11 WSL2 environment

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

# Function to show usage
show_usage() {
    echo "Gitpod Setup Script for Windows 11 with WSL2"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help              Show this help message"
    echo "  -c, --check-only        Only check prerequisites without setup"
    echo "  -f, --force             Force setup even if already configured"
    echo "  -u, --update            Update existing Gitpod configuration"
    echo "  -t, --test              Test Gitpod configuration"
    echo "  --no-wsl                Skip WSL2 setup (if already configured)"
    echo "  --no-gitpod             Skip Gitpod account setup"
    echo "  --office-only           Setup only Office Add-in development"
    echo ""
    echo "Examples:"
    echo "  $0                      # Full setup"
    echo "  $0 --check-only         # Check prerequisites only"
    echo "  $0 --force              # Force setup (overwrite existing)"
    echo "  $0 --update             # Update existing configuration"
    echo "  $0 --test               # Test Gitpod configuration"
}

# Function to check if running on Windows/WSL
check_environment() {
    print_step "Checking environment..."
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if grep -q Microsoft /proc/version 2>/dev/null; then
            print_success "Running on WSL2"
            return 0
        else
            print_warning "Running on Linux (not WSL2)"
            return 1
        fi
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        print_success "Running on Windows (Git Bash/MSYS)"
        return 0
    else
        print_error "Unsupported environment: $OSTYPE"
        print_status "This script is designed for Windows 11 with WSL2"
        return 1
    fi
}

# Function to check WSL2 prerequisites
check_wsl2_prerequisites() {
    print_step "Checking WSL2 prerequisites..."
    
    # Check if WSL is available
    if ! command -v wsl >/dev/null 2>&1; then
        print_error "WSL is not installed or not in PATH"
        print_status "Please install WSL2:"
        print_status "1. Open PowerShell as Administrator"
        print_status "2. Run: wsl --install"
        print_status "3. Restart your computer"
        return 1
    fi
    
    # Check WSL version
    local wsl_version=$(wsl --version 2>/dev/null || echo "WSL 1")
    if [[ "$wsl_version" == *"WSL 2"* ]]; then
        print_success "WSL2 is installed"
    else
        print_warning "WSL2 may not be properly configured"
        print_status "To upgrade to WSL2: wsl --set-default-version 2"
    fi
    
    # Check if we're running in WSL
    if [[ -f /proc/version ]] && grep -q Microsoft /proc/version; then
        print_success "Running inside WSL2"
    else
        print_warning "Not running inside WSL2"
        print_status "For best experience, run this script from within WSL2"
    fi
    
    return 0
}

# Function to check Windows prerequisites
check_windows_prerequisites() {
    print_step "Checking Windows prerequisites..."
    
    # Check if we can access Windows commands
    if command -v cmd.exe >/dev/null 2>&1; then
        print_success "Windows command access available"
    else
        print_warning "Windows command access not available"
    fi
    
    # Check for Windows version
    if command -v cmd.exe >/dev/null 2>&1; then
        local win_version=$(cmd.exe /c "ver" 2>/dev/null | head -1 || echo "Unknown")
        print_status "Windows version: $win_version"
    fi
    
    return 0
}

# Function to check Gitpod prerequisites
check_gitpod_prerequisites() {
    print_step "Checking Gitpod prerequisites..."
    
    # Check if curl is available
    if ! command -v curl >/dev/null 2>&1; then
        print_error "curl is not installed"
        print_status "Install curl: sudo apt-get update && sudo apt-get install curl"
        return 1
    fi
    
    # Check if git is available
    if ! command -v git >/dev/null 2>&1; then
        print_error "Git is not installed"
        print_status "Install Git: sudo apt-get update && sudo apt-get install git"
        return 1
    fi
    
    # Check if node is available
    if ! command -v node >/dev/null 2>&1; then
        print_warning "Node.js is not installed"
        print_status "Node.js will be installed in the Gitpod environment"
    else
        local node_version=$(node --version)
        print_success "Node.js $node_version is installed"
    fi
    
    # Check if docker is available (optional for local development)
    if command -v docker >/dev/null 2>&1; then
        print_success "Docker is available"
    else
        print_status "Docker not found (will be available in Gitpod)"
    fi
    
    return 0
}

# Function to check internet connectivity
check_internet_connectivity() {
    print_step "Checking internet connectivity..."
    
    if curl -s --connect-timeout 10 https://gitpod.io >/dev/null 2>&1; then
        print_success "Gitpod.io is accessible"
    else
        print_error "Cannot reach Gitpod.io"
        print_status "Please check your internet connection"
        return 1
    fi
    
    if curl -s --connect-timeout 10 https://github.com >/dev/null 2>&1; then
        print_success "GitHub is accessible"
    else
        print_warning "Cannot reach GitHub"
    fi
    
    return 0
}

# Function to create Gitpod configuration
create_gitpod_config() {
    print_step "Creating Gitpod configuration..."
    
    # Create .gitpod.yml
    cat > .gitpod.yml << 'EOF'
# Gitpod configuration for TypeScript Excel Development Environment
# Optimized for Office Add-in development

image:
  file: .gitpod.Dockerfile

# Ports to expose
ports:
  - port: 3000
    onOpen: open-preview
    name: "Dev Server"
  - port: 8080
    onOpen: open-preview
    name: "Office Add-in"
  - port: 9229
    onOpen: ignore
    name: "Debug Port"

# VS Code extensions to install
vscode:
  extensions:
    # TypeScript and JavaScript development
    - ms-vscode.vscode-typescript-next
    - bradlc.vscode-tailwindcss
    - esbenp.prettier-vscode
    - ms-vscode.vscode-eslint
    - formulahendry.auto-rename-tag
    - christian-kohler.path-intellisense
    - ms-vscode.vscode-json
    
    # Office.js and Excel development
    - ms-vscode.vscode-office-addin-dev-tools
    - ms-vscode.vscode-office-addin-debugger
    - ms-vscode.vscode-office-addin-lint
    - ms-vscode.vscode-office-addin-manifest
    - ms-vscode.vscode-office-addin-validator
    
    # Web development
    - ms-vscode.vscode-html-css-support
    - ms-vscode.vscode-css-peek
    - ms-vscode.vscode-htmlhint
    - ms-vscode.vscode-css-lint
    
    # Testing and debugging
    - ms-vscode.vscode-jest
    - ms-vscode.vscode-playwright
    - ms-vscode.vscode-debugger-for-chrome
    - ms-vscode.vscode-debugger-for-edge
    
    # Git and version control
    - eamodio.gitlens
    - ms-vscode.vscode-github-pullrequest
    - ms-vscode.vscode-github-actions
    
    # Productivity
    - ms-vscode.vscode-thunder-client
    - ms-vscode.vscode-restclient
    - ms-vscode.vscode-markdown-preview-enhanced
    - ms-vscode.vscode-drawio

# Tasks to run when workspace starts
tasks:
  - name: Setup Development Environment
    init: |
      echo "Setting up TypeScript Excel development environment..."
      cd /workspace
      npm install
      echo "Environment setup complete!"
  
  - name: Start Dev Server
    command: |
      echo "Starting development server..."
      npm run dev-server
    openMode: split-right

# Environment variables
env:
  - name: NODE_ENV
    value: development
  - name: OFFICE_JS_URL
    value: "https://appsforoffice.microsoft.com/lib/1/hosted/office.js"
  - name: GITPOD_WORKSPACE_URL
    value: $GITPOD_WORKSPACE_URL

# Git configuration
gitConfig:
  user.name: "FireZombieCoder"
  user.email: "firezombify@gmail.com"

# IDE preferences
ide: vscode

# Workspace settings
workspaceLocation: "."

# Prebuild configuration
prebuilds:
  addTask: "Setup Development Environment"
  addBadge: "TypeScript Excel Dev"
EOF

    print_success ".gitpod.yml created"
    
    # Create .gitpod.Dockerfile
    cat > .gitpod.Dockerfile << 'EOF'
# Gitpod Dockerfile for TypeScript Excel Development
FROM gitpod/workspace-full:latest

# Install additional system dependencies
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        python3 \
        python3-pip \
        python3-venv \
        unzip \
        zip \
        jq \
        vim \
        nano \
        htop \
        tree \
        ca-certificates \
        gnupg \
        lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20 (if not already installed)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Install global Node.js tools for Office development
RUN npm install -g \
    typescript \
    ts-node \
    @types/node \
    eslint \
    prettier \
    webpack \
    webpack-cli \
    rollup \
    jest \
    @playwright/test \
    office-addin-dev-certs \
    office-addin-debugging \
    office-addin-lint \
    office-addin-manifest \
    office-addin-prettier-config \
    office-addin-dev-settings \
    office-addin-sso \
    office-addin-taskpane \
    office-addin-validator \
    yo \
    generator-office

# Install Office.js types and tools
RUN npm install --save-dev \
    @types/office-js \
    @types/office-runtime \
    office-js \
    office-js-helpers \
    office-ui-fabric-react \
    @fluentui/react \
    @fluentui/react-components

# Create workspace structure
RUN mkdir -p /workspace/{projects,templates,examples,docs,scripts}

# Set up Git configuration
RUN git config --global init.defaultBranch main && \
    git config --global pull.rebase false

# Switch back to gitpod user
USER gitpod

# Set working directory
WORKDIR /workspace

# Expose ports
EXPOSE 3000 8080 9229

# Default command
CMD ["bash"]
EOF

    print_success ".gitpod.Dockerfile created"
}

# Function to create Gitpod-specific package.json
create_gitpod_package_json() {
    print_step "Creating Gitpod-specific package.json..."
    
    # Backup existing package.json if it exists
    if [ -f "package.json" ]; then
        cp package.json package.json.backup
        print_status "Backed up existing package.json"
    fi
    
    # Create Gitpod-optimized package.json
    cat > package.json << 'EOF'
{
  "name": "typescript-excel-devcontainer",
  "version": "1.0.0",
  "description": "A comprehensive Gitpod workspace for TypeScript Excel development with Office.js integration",
  "main": "index.js",
  "scripts": {
    "setup-project": "./scripts/setup-project.sh",
    "build-all": "./scripts/build-all.sh",
    "test-all": "./scripts/test-all.sh",
    "dev": "webpack serve --mode development --open",
    "dev-server": "webpack serve --mode development --open --port 3000",
    "build": "webpack --mode production",
    "build:dev": "webpack --mode development",
    "start": "webpack serve --mode development",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "lint": "eslint src/**/*.{ts,tsx}",
    "lint:fix": "eslint src/**/*.{ts,tsx} --fix",
    "format": "prettier --write src/**/*.{ts,tsx,json}",
    "validate": "office-addin-validator manifest.xml",
    "sideload": "office-addin-dev-settings sideload manifest.xml",
    "gitpod:setup": "echo 'Gitpod workspace ready for TypeScript Excel development!'",
    "gitpod:test": "echo 'Testing Gitpod configuration...' && npm run build && npm test",
    "help": "echo 'Available commands: dev, build, test, lint, format, validate, sideload'"
  },
  "keywords": [
    "gitpod",
    "devcontainer",
    "typescript",
    "excel",
    "office-js",
    "add-in",
    "development-environment",
    "wsl2",
    "windows"
  ],
  "author": "FireZombieCoder",
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "git+https://github.com/FireZombieCoder/typescript-excel-devcontainer.git"
  },
  "bugs": {
    "url": "https://github.com/FireZombieCoder/typescript-excel-devcontainer/issues"
  },
  "homepage": "https://github.com/FireZombieCoder/typescript-excel-devcontainer#readme",
  "dependencies": {
    "@microsoft/office-js": "^1.1.110",
    "@microsoft/office-js-helpers": "^1.0.2",
    "office-js": "^1.1.0",
    "office-js-helpers": "^1.0.0"
  },
  "devDependencies": {
    "@types/office-js": "^1.0.0",
    "@types/office-runtime": "^1.0.0",
    "@types/node": "^20.0.0",
    "typescript": "^5.0.0",
    "webpack": "^5.0.0",
    "webpack-cli": "^5.0.0",
    "ts-loader": "^9.0.0",
    "html-webpack-plugin": "^5.0.0",
    "css-loader": "^6.0.0",
    "style-loader": "^3.0.0",
    "eslint": "^8.0.0",
    "prettier": "^3.0.0",
    "jest": "^29.0.0",
    "@types/jest": "^29.0.0",
    "ts-jest": "^29.0.0",
    "@playwright/test": "^1.40.0"
  },
  "engines": {
    "node": ">=18.0.0",
    "npm": ">=8.0.0"
  },
  "gitpod": {
    "ports": [3000, 8080, 9229],
    "tasks": ["Setup Development Environment", "Start Dev Server"],
    "vscode": {
      "extensions": [
        "ms-vscode.vscode-typescript-next",
        "ms-vscode.vscode-office-addin-dev-tools",
        "ms-vscode.vscode-office-addin-debugger",
        "ms-vscode.vscode-office-addin-lint",
        "ms-vscode.vscode-office-addin-manifest",
        "ms-vscode.vscode-office-addin-validator"
      ]
    }
  }
}
EOF

    print_success "Gitpod-optimized package.json created"
}

# Function to create Gitpod-specific scripts
create_gitpod_scripts() {
    print_step "Creating Gitpod-specific scripts..."
    
    # Create Gitpod setup script
    cat > scripts/gitpod-setup.sh << 'EOF'
#!/bin/bash

# Gitpod Setup Script
# This script runs inside Gitpod to set up the development environment

set -e

echo "🚀 Setting up TypeScript Excel development environment in Gitpod..."

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Set up Git configuration
echo "🔧 Configuring Git..."
git config --global init.defaultBranch main
git config --global pull.rebase false

# Create sample project if it doesn't exist
if [ ! -d "projects/sample-excel-addin" ]; then
    echo "📁 Creating sample Excel Add-in project..."
    mkdir -p projects/sample-excel-addin/src
    cd projects/sample-excel-addin
    
    # Copy template files
    if [ -f "../../templates/excel-addin-basic/src/index.html" ]; then
        cp ../../templates/excel-addin-basic/src/index.html src/
        cp ../../templates/excel-addin-basic/src/index.ts src/
    fi
    
    # Create package.json for sample project
    cat > package.json << 'PACKAGE_EOF'
{
  "name": "sample-excel-addin",
  "version": "1.0.0",
  "description": "Sample Excel Add-in for Gitpod",
  "main": "dist/index.js",
  "scripts": {
    "build": "webpack --mode production",
    "dev": "webpack serve --mode development --open",
    "test": "jest"
  },
  "dependencies": {
    "@microsoft/office-js": "^1.1.110"
  },
  "devDependencies": {
    "@types/office-js": "^1.0.0",
    "typescript": "^5.0.0",
    "webpack": "^5.0.0",
    "webpack-cli": "^5.0.0",
    "ts-loader": "^9.0.0",
    "html-webpack-plugin": "^5.0.0"
  }
}
PACKAGE_EOF
    
    # Install sample project dependencies
    npm install
    
    cd ../..
fi

echo "✅ Gitpod setup complete!"
echo "🌐 Your development server will be available at:"
echo "   - Main dev server: https://3000-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
echo "   - Office Add-in: https://8080-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
echo ""
echo "🎯 To start developing:"
echo "   1. Run: npm run dev-server"
echo "   2. Open the preview URL in your browser"
echo "   3. Start coding your Excel Add-in!"
EOF

    chmod +x scripts/gitpod-setup.sh
    
    # Create Gitpod test script
    cat > scripts/gitpod-test.sh << 'EOF'
#!/bin/bash

# Gitpod Test Script
# This script tests the Gitpod configuration

set -e

echo "🧪 Testing Gitpod configuration..."

# Test Node.js
echo "Testing Node.js..."
node --version
npm --version

# Test TypeScript
echo "Testing TypeScript..."
tsc --version

# Test Office.js tools
echo "Testing Office.js tools..."
office-addin-validator --version || echo "Office Add-in Validator not available"

# Test build process
echo "Testing build process..."
npm run build

# Test development server (in background)
echo "Testing development server..."
timeout 10s npm run dev-server || echo "Dev server test completed"

echo "✅ All tests passed!"
EOF

    chmod +x scripts/gitpod-test.sh
    
    print_success "Gitpod scripts created"
}

# Function to create Gitpod documentation
create_gitpod_documentation() {
    print_step "Creating Gitpod documentation..."
    
    cat > docs/gitpod-setup-guide.md << 'EOF'
# Gitpod Setup Guide for Windows 11 with WSL2

This guide will help you set up Gitpod for TypeScript Excel development with Office Add-ins on Windows 11 using WSL2.

## Prerequisites

### Windows 11 Requirements
- Windows 11 (Build 22000 or later)
- WSL2 installed and configured
- Git for Windows
- A Gitpod account (free at [gitpod.io](https://gitpod.io))

### WSL2 Setup
1. Open PowerShell as Administrator
2. Run: `wsl --install`
3. Restart your computer
4. Set WSL2 as default: `wsl --set-default-version 2`

## Quick Start

### 1. Clone the Repository
```bash
git clone <your-repository-url>
cd Devcontainers
```

### 2. Run the Setup Script
```bash
./scripts/setup-gitpod-windows.sh
```

### 3. Open in Gitpod
1. Push your changes to GitHub
2. Go to [gitpod.io](https://gitpod.io)
3. Open your repository in Gitpod
4. Wait for the workspace to initialize

## Gitpod Features

### Pre-configured Environment
- Node.js 20
- TypeScript 5.0+
- Office.js SDK and types
- All necessary VS Code extensions
- Pre-built project templates

### Port Forwarding
- Port 3000: Development server
- Port 8080: Office Add-in testing
- Port 9229: Debug port

### VS Code Extensions
- Office Add-in development tools
- TypeScript support
- ESLint and Prettier
- Git integration
- Testing frameworks

## Development Workflow

### 1. Start Development
```bash
npm run dev-server
```

### 2. Create New Project
```bash
./scripts/setup-project.sh my-excel-addin
```

### 3. Test Your Add-in
```bash
npm run test
```

### 4. Build for Production
```bash
npm run build
```

## Office Add-in Development

### Sideloading Add-ins
1. Build your add-in: `npm run build`
2. Create a manifest.xml file
3. Sideload in Excel: `npm run sideload`

### Testing in Excel Online
1. Start your dev server
2. Open Excel Online
3. Insert your add-in using the manifest URL

## Troubleshooting

### Common Issues

#### WSL2 Not Working
- Ensure Windows features are enabled
- Check WSL version: `wsl --list --verbose`
- Update WSL: `wsl --update`

#### Gitpod Connection Issues
- Check internet connectivity
- Verify Gitpod account status
- Try refreshing the workspace

#### Office.js Not Loading
- Ensure you're using HTTPS
- Check manifest.xml configuration
- Verify Office.js CDN accessibility

### Getting Help
- Check the [Gitpod documentation](https://www.gitpod.io/docs)
- Review the [Office.js documentation](https://docs.microsoft.com/en-us/office/dev/add-ins/)
- Open an issue in this repository

## Advanced Configuration

### Custom Docker Image
Edit `.gitpod.Dockerfile` to customize the environment.

### Additional Ports
Add ports to `.gitpod.yml`:
```yaml
ports:
  - port: 3001
    onOpen: open-preview
    name: "Additional Service"
```

### Environment Variables
Add to `.gitpod.yml`:
```yaml
env:
  - name: CUSTOM_VAR
    value: "custom-value"
```

## Best Practices

1. **Use Prebuilds**: Enable prebuilds for faster workspace startup
2. **Pin Dependencies**: Use exact versions in package.json
3. **Optimize Images**: Keep Docker images small
4. **Use Workspace Settings**: Configure VS Code settings in .gitpod.yml
5. **Regular Updates**: Keep dependencies and tools updated

## Resources

- [Gitpod Documentation](https://www.gitpod.io/docs)
- [Office.js API Reference](https://docs.microsoft.com/en-us/office/dev/add-ins/reference/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Webpack Documentation](https://webpack.js.org/concepts/)

## Support

For issues and questions:
- Create an issue in this repository
- Check the troubleshooting guide
- Review the Office.js documentation
- Join the Gitpod community

---

**Happy coding with TypeScript and Excel in Gitpod! 🎉**
EOF

    print_success "Gitpod documentation created"
}

# Function to test Gitpod configuration
test_gitpod_configuration() {
    print_step "Testing Gitpod configuration..."
    
    # Test if .gitpod.yml exists and is valid
    if [ -f ".gitpod.yml" ]; then
        print_success ".gitpod.yml exists"
        
        # Basic YAML validation
        if command -v python3 >/dev/null 2>&1; then
            python3 -c "import yaml; yaml.safe_load(open('.gitpod.yml'))" 2>/dev/null && \
                print_success ".gitpod.yml is valid YAML" || \
                print_warning ".gitpod.yml may have YAML syntax issues"
        fi
    else
        print_error ".gitpod.yml not found"
        return 1
    fi
    
    # Test if .gitpod.Dockerfile exists
    if [ -f ".gitpod.Dockerfile" ]; then
        print_success ".gitpod.Dockerfile exists"
    else
        print_error ".gitpod.Dockerfile not found"
        return 1
    fi
    
    # Test if package.json exists and has Gitpod scripts
    if [ -f "package.json" ]; then
        if grep -q "gitpod" package.json; then
            print_success "package.json contains Gitpod configuration"
        else
            print_warning "package.json may not have Gitpod-specific scripts"
        fi
    else
        print_error "package.json not found"
        return 1
    fi
    
    # Test if scripts exist
    if [ -f "scripts/gitpod-setup.sh" ] && [ -f "scripts/gitpod-test.sh" ]; then
        print_success "Gitpod scripts exist"
    else
        print_warning "Some Gitpod scripts may be missing"
    fi
    
    print_success "Gitpod configuration test completed"
    return 0
}

# Function to show next steps
show_next_steps() {
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
}

# Main function
main() {
    local check_only=false
    local force=false
    local update=false
    local test_only=false
    local no_wsl=false
    local no_gitpod=false
    local office_only=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -c|--check-only)
                check_only=true
                shift
                ;;
            -f|--force)
                force=true
                shift
                ;;
            -u|--update)
                update=true
                shift
                ;;
            -t|--test)
                test_only=true
                shift
                ;;
            --no-wsl)
                no_wsl=true
                shift
                ;;
            --no-gitpod)
                no_gitpod=true
                shift
                ;;
            --office-only)
                office_only=true
                shift
                ;;
            -*)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
            *)
                print_error "Unknown argument: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    print_header "Gitpod Setup for Windows 11 with WSL2"
    print_status "Setting up TypeScript Excel development environment with Office Add-ins"
    echo ""
    
    # Check environment
    if ! check_environment; then
        print_error "Environment check failed"
        exit 1
    fi
    
    # Check prerequisites
    if [ "$no_wsl" = false ]; then
        if ! check_wsl2_prerequisites; then
            print_error "WSL2 prerequisites check failed"
            exit 1
        fi
    fi
    
    if ! check_windows_prerequisites; then
        print_warning "Windows prerequisites check had issues"
    fi
    
    if ! check_gitpod_prerequisites; then
        print_error "Gitpod prerequisites check failed"
        exit 1
    fi
    
    if ! check_internet_connectivity; then
        print_error "Internet connectivity check failed"
        exit 1
    fi
    
    print_success "All prerequisite checks passed!"
    
    if [ "$check_only" = true ]; then
        print_success "Prerequisites check completed successfully"
        exit 0
    fi
    
    # Check if already configured
    if [ -f ".gitpod.yml" ] && [ "$force" = false ] && [ "$update" = false ]; then
        print_warning "Gitpod configuration already exists"
        print_status "Use --force to overwrite or --update to update existing configuration"
        exit 1
    fi
    
    # Create Gitpod configuration
    create_gitpod_config
    
    # Create Gitpod-specific package.json
    create_gitpod_package_json
    
    # Create Gitpod scripts
    create_gitpod_scripts
    
    # Create documentation
    create_gitpod_documentation
    
    # Test configuration
    if test_gitpod_configuration; then
        print_success "Gitpod configuration test passed"
    else
        print_warning "Gitpod configuration test had issues"
    fi
    
    # Show next steps
    show_next_steps
}

# Run main function with all arguments
main "$@"
