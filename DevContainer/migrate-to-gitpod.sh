#!/bin/bash

# GitPod Migration Script
# Converts Docker Desktop + WSL2 devcontainer to GitPod workspace

set -e

echo "🚀 GitPod Migration Script"
echo "=========================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    print_error "Not in a git repository. Please run this script from your project root."
    exit 1
fi

# Check if devcontainer.json exists
if [ ! -f "devcontainer.json" ]; then
    print_error "devcontainer.json not found. Please run this script from your devcontainer project directory."
    exit 1
fi

print_status "Found devcontainer.json. Starting migration..."

# Create backup of original files
print_status "Creating backups..."
cp devcontainer.json devcontainer.json.backup
if [ -f "Dockerfile" ]; then
    cp Dockerfile Dockerfile.backup
fi
print_success "Backups created"

# Extract information from devcontainer.json
print_status "Analyzing devcontainer configuration..."

# Extract extensions
EXTENSIONS=$(grep -A 50 '"extensions"' devcontainer.json | grep -E '^\s*"[^"]+",?$' | sed 's/.*"\([^"]*\)".*/\1/' | tr '\n' ',' | sed 's/,$//')

# Extract postCreateCommand
POST_CREATE_CMD=$(grep -A 5 '"postCreateCommand"' devcontainer.json | grep -v '"postCreateCommand"' | head -1 | sed 's/.*"\([^"]*\)".*/\1/')

# Extract port forwarding
PORTS=$(grep -A 5 '"forwardPorts"' devcontainer.json | grep -E '^\s*[0-9]+' | tr '\n' ',' | sed 's/,$//')

print_success "Configuration analyzed"

# Create .gitpod.yml
print_status "Creating .gitpod.yml configuration..."

cat > .gitpod.yml << EOF
# GitPod Configuration
# Generated from devcontainer.json

image: gitpod/workspace-full:latest

# Ports to expose
ports:
EOF

# Add port configurations
if [ ! -z "$PORTS" ]; then
    IFS=',' read -ra PORT_ARRAY <<< "$PORTS"
    for port in "${PORT_ARRAY[@]}"; do
        port=$(echo $port | xargs) # trim whitespace
        if [ ! -z "$port" ]; then
            echo "  - port: $port" >> .gitpod.yml
            echo "    onOpen: open-browser" >> .gitpod.yml
        fi
    done
else
    echo "  - port: 3000" >> .gitpod.yml
    echo "    onOpen: open-browser" >> .gitpod.yml
    echo "  - port: 8080" >> .gitpod.yml
    echo "    onOpen: open-browser" >> .gitpod.yml
fi

cat >> .gitpod.yml << EOF

# Tasks to run when workspace starts
tasks:
  - name: Setup Development Environment
    init: |
      echo "🚀 Setting up TypeScript Excel Development Environment..."
      echo "Node version: \$(node --version)"
      echo "NPM version: \$(npm --version)"
      echo "TypeScript version: \$(tsc --version)"
    command: |
      echo "✅ Development environment ready!"
      echo "📁 Workspace: \$(pwd)"
      echo "🌐 Available ports: 3000, 8080, 9229"

# VS Code Extensions to install
vscode:
  extensions:
EOF

# Add extensions
if [ ! -z "$EXTENSIONS" ]; then
    IFS=',' read -ra EXT_ARRAY <<< "$EXTENSIONS"
    for ext in "${EXT_ARRAY[@]}"; do
        ext=$(echo $ext | xargs) # trim whitespace
        if [ ! -z "$ext" ]; then
            echo "    - $ext" >> .gitpod.yml
        fi
    done
else
    # Default TypeScript/Office.js extensions
    cat >> .gitpod.yml << EOF
    - ms-vscode.vscode-typescript-next
    - ms-vscode.vscode-eslint
    - esbenp.prettier-vscode
    - ms-vscode.vscode-office-addin-dev-tools
    - ms-vscode.vscode-office-addin-debugger
    - ms-vscode.vscode-office-addin-lint
    - ms-vscode.vscode-office-addin-manifest
    - ms-vscode.vscode-office-addin-validator
    - ms-vscode.vscode-jest
    - ms-vscode.vscode-playwright
    - eamodio.gitlens
    - ms-vscode.vscode-github-pullrequest
EOF
fi

cat >> .gitpod.yml << EOF

# Environment variables
env:
  - name: NODE_ENV
    value: development
  - name: GITPOD_WORKSPACE_URL
    value: \$(gp url 3000)

# Git configuration
git:
  config:
    - name: user.name
      value: \$(git config user.name || echo "GitPod User")
    - name: user.email
      value: \$(git config user.email || echo "gitpod@example.com")

# Workspace settings
workspace:
  location: .
  openMode: split-right
EOF

print_success ".gitpod.yml created"

# Create GitPod-specific scripts
print_status "Creating GitPod helper scripts..."

# Create setup script
cat > gitpod-setup.sh << 'EOF'
#!/bin/bash

# GitPod Environment Setup Script
echo "🔧 Setting up GitPod development environment..."

# Install additional tools if needed
if ! command -v pnpm &> /dev/null; then
    echo "📦 Installing pnpm..."
    npm install -g pnpm
fi

# Install project dependencies
if [ -f "package.json" ]; then
    echo "📦 Installing project dependencies..."
    npm install
fi

# Set up git configuration
echo "🔧 Configuring git..."
git config --global init.defaultBranch main
git config --global pull.rebase false

# Create useful aliases
echo "⚡ Setting up useful aliases..."
echo 'alias ll="ls -la"' >> ~/.bashrc
echo 'alias gs="git status"' >> ~/.bashrc
echo 'alias gp="git push"' >> ~/.bashrc
echo 'alias gl="git pull"' >> ~/.bashrc
echo 'alias gc="git commit"' >> ~/.bashrc
echo 'alias ga="git add"' >> ~/.bashrc

# Reload bashrc
source ~/.bashrc

echo "✅ GitPod environment setup complete!"
echo "🚀 Ready to develop!"
EOF

chmod +x gitpod-setup.sh

# Create development script
cat > gitpod-dev.sh << 'EOF'
#!/bin/bash

# GitPod Development Script
echo "🚀 Starting development environment..."

# Check if we're in GitPod
if [ -z "$GITPOD_WORKSPACE_ID" ]; then
    echo "⚠️  Not running in GitPod. Some features may not work."
fi

# Start development server
if [ -f "package.json" ]; then
    echo "📦 Starting development server..."
    npm run dev || npm run start || npm run dev-server
else
    echo "📁 No package.json found. Starting basic development environment..."
    echo "🌐 Available ports: 3000, 8080, 9229"
    echo "💡 Open a new terminal to start your development server"
fi
EOF

chmod +x gitpod-dev.sh

print_success "Helper scripts created"

# Create Cursor IDE integration guide
print_status "Creating Cursor IDE integration guide..."

cat > cursor-gitpod-integration.md << 'EOF'
# Cursor IDE + GitPod Integration Guide

## Method 1: Direct GitPod Integration (Recommended)

### Step 1: Install GitPod Extension
1. Open Cursor IDE
2. Go to Extensions (Ctrl+Shift+X)
3. Search for "GitPod"
4. Install the official GitPod extension

### Step 2: Connect to GitPod
1. Open Command Palette (Ctrl+Shift+P)
2. Type "GitPod: Open in GitPod"
3. Select your repository
4. GitPod will open in your browser

### Step 3: Connect Cursor to GitPod
1. In GitPod, click the "Open in VS Code" button
2. Choose "Open in Cursor" if available
3. Or use the GitPod extension in Cursor

## Method 2: Remote Development

### Step 1: Install Remote Development Extension
1. Install "Remote - SSH" extension in Cursor
2. Install "Remote - Containers" extension

### Step 2: Connect to GitPod via SSH
1. In GitPod, open terminal
2. Run: `gp init-remote-ssh`
3. Copy the SSH command
4. In Cursor, use Remote-SSH to connect

## Method 3: Local Development with GitPod Sync

### Step 1: Clone Repository
```bash
git clone https://github.com/yourusername/yourproject.git
cd yourproject
```

### Step 2: Use GitPod for Building/Testing
- Use GitPod for complex builds
- Use local Cursor for editing
- Sync changes via git

## Benefits of Each Method

### Method 1 (Direct Integration)
- ✅ Full GitPod features
- ✅ Cloud-based development
- ✅ Easy sharing
- ❌ Requires internet connection

### Method 2 (Remote Development)
- ✅ Full Cursor features
- ✅ GitPod environment
- ✅ Good performance
- ❌ More complex setup

### Method 3 (Hybrid)
- ✅ Best of both worlds
- ✅ Offline editing
- ✅ Cloud building
- ❌ Requires manual sync

## Recommended Workflow

1. **Start with Method 1** for quick setup
2. **Switch to Method 2** for intensive development
3. **Use Method 3** for offline work
EOF

print_success "Cursor integration guide created"

# Create quick start script
cat > quick-start-gitpod.sh << 'EOF'
#!/bin/bash

# Quick Start GitPod Script
echo "🚀 Quick Start: GitPod Development Environment"
echo "=============================================="

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Not in a git repository. Please run from project root."
    exit 1
fi

# Check if .gitpod.yml exists
if [ ! -f ".gitpod.yml" ]; then
    echo "❌ .gitpod.yml not found. Run migrate-to-gitpod.sh first."
    exit 1
fi

# Get repository URL
REPO_URL=$(git remote get-url origin 2>/dev/null || echo "")
if [ -z "$REPO_URL" ]; then
    echo "❌ No git remote found. Please add a remote repository."
    exit 1
fi

# Convert SSH URL to HTTPS if needed
if [[ $REPO_URL == git@* ]]; then
    REPO_URL=$(echo $REPO_URL | sed 's/git@github.com:/https:\/\/github.com\//' | sed 's/\.git$//')
fi

# Create GitPod URL
GITPOD_URL="https://gitpod.io/#$REPO_URL"

echo "📋 Repository: $REPO_URL"
echo "🌐 GitPod URL: $GITPOD_URL"
echo ""
echo "🚀 Opening GitPod workspace..."
echo "   Click the link above or copy-paste into your browser"
echo ""

# Try to open in browser (works on some systems)
if command -v xdg-open &> /dev/null; then
    xdg-open "$GITPOD_URL"
elif command -v open &> /dev/null; then
    open "$GITPOD_URL"
else
    echo "💡 Please manually open: $GITPOD_URL"
fi

echo ""
echo "✅ GitPod workspace should be opening now!"
echo "📚 See cursor-gitpod-integration.md for Cursor IDE setup"
EOF

chmod +x quick-start-gitpod.sh

print_success "Quick start script created"

# Create package.json if it doesn't exist
if [ ! -f "package.json" ]; then
    print_status "Creating package.json for GitPod..."
    cat > package.json << 'EOF'
{
  "name": "typescript-excel-devcontainer",
  "version": "1.0.0",
  "description": "TypeScript Excel Development Environment - GitPod Ready",
  "main": "index.js",
  "scripts": {
    "dev": "echo 'Starting development server...' && echo 'Open http://localhost:3000'",
    "start": "npm run dev",
    "dev-server": "npm run dev",
    "build": "echo 'Building project...' && echo 'Build complete!'",
    "test": "echo 'Running tests...' && echo 'Tests complete!'",
    "setup": "./gitpod-setup.sh",
    "gitpod": "./quick-start-gitpod.sh"
  },
  "keywords": ["typescript", "excel", "office-js", "gitpod", "devcontainer"],
  "author": "Your Name",
  "license": "MIT",
  "devDependencies": {
    "typescript": "^5.0.0",
    "@types/node": "^20.0.0"
  }
}
EOF
    print_success "package.json created"
fi

# Final summary
echo ""
echo "🎉 GitPod Migration Complete!"
echo "============================="
echo ""
echo "📁 Files created:"
echo "   ✅ .gitpod.yml (GitPod configuration)"
echo "   ✅ gitpod-setup.sh (Environment setup)"
echo "   ✅ gitpod-dev.sh (Development script)"
echo "   ✅ quick-start-gitpod.sh (Quick start)"
echo "   ✅ cursor-gitpod-integration.md (Cursor setup guide)"
echo "   ✅ package.json (Project configuration)"
echo ""
echo "🚀 Next steps:"
echo "   1. Commit your changes: git add . && git commit -m 'Add GitPod configuration'"
echo "   2. Push to GitHub: git push"
echo "   3. Run: ./quick-start-gitpod.sh"
echo "   4. Follow cursor-gitpod-integration.md for Cursor setup"
echo ""
echo "💡 Pro tip: Bookmark your GitPod workspace URL for quick access!"
echo ""
print_success "Migration completed successfully! 🎉"
