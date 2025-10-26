#!/bin/bash

# Gitpod Setup Script
# This script runs inside Gitpod to set up the development environment

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

print_header "Gitpod TypeScript Excel Development Setup"

echo "🚀 Setting up TypeScript Excel development environment in Gitpod..."

# Check if we're in Gitpod
if [ -z "$GITPOD_WORKSPACE_ID" ]; then
    print_warning "Not running in Gitpod environment"
    print_status "This script is optimized for Gitpod but will work in other environments"
else
    print_success "Running in Gitpod workspace: $GITPOD_WORKSPACE_ID"
fi

# Install dependencies
print_step "Installing dependencies..."
if [ -f "package.json" ]; then
    npm install
    print_success "Dependencies installed successfully"
else
    print_warning "No package.json found, creating basic setup..."
    npm init -y
    npm install --save-dev typescript @types/node webpack webpack-cli ts-loader html-webpack-plugin
    npm install --save office-js @types/office-js
fi

# Set up Git configuration
print_step "Configuring Git..."
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global user.name "Gitpod User"
git config --global user.email "gitpod@example.com"
print_success "Git configured"

# Create workspace structure
print_step "Creating workspace structure..."
mkdir -p projects templates examples docs scripts
print_success "Workspace structure created"

# Create sample project if it doesn't exist
if [ ! -d "projects/sample-excel-addin" ]; then
    print_step "Creating sample Excel Add-in project..."
    mkdir -p projects/sample-excel-addin/src
    cd projects/sample-excel-addin
    
    # Copy template files if they exist
    if [ -f "../../templates/excel-addin-basic/src/index.html" ]; then
        cp ../../templates/excel-addin-basic/src/index.html src/
        cp ../../templates/excel-addin-basic/src/index.ts src/
        print_success "Template files copied"
    else
        # Create basic files
        cat > src/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Excel Add-in</title>
    <script src="https://appsforoffice.microsoft.com/lib/1/hosted/office.js"></script>
</head>
<body>
    <div id="content">
        <h1>Excel Add-in</h1>
        <button id="run">Run</button>
        <div id="result"></div>
    </div>
    <script src="bundle.js"></script>
</body>
</html>
EOF

        cat > src/index.ts << 'EOF'
// Initialize Office.js
Office.onReady((info) => {
    if (info.host === Office.HostType.Excel) {
        document.getElementById('run')?.addEventListener('click', run);
    }
});

async function run() {
    try {
        await Excel.run(async (context) => {
            const range = context.workbook.getSelectedRange();
            range.format.fill.color = 'yellow';
            range.values = [['Hello from Excel Add-in!']];
            await context.sync();
        });
    } catch (error) {
        console.error('Error:', error);
    }
}
EOF
        print_success "Basic files created"
    fi
    
    # Create package.json for sample project
    cat > package.json << 'EOF'
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
EOF
    
    # Install sample project dependencies
    npm install
    print_success "Sample project created and dependencies installed"
    
    cd ../..
fi

# Create webpack configuration if it doesn't exist
if [ ! -f "webpack.config.js" ]; then
    print_step "Creating webpack configuration..."
    cat > webpack.config.js << 'EOF'
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  entry: './src/index.ts',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'bundle.js',
    clean: true,
  },
  resolve: {
    extensions: ['.ts', '.tsx', '.js', '.jsx'],
  },
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        use: 'ts-loader',
        exclude: /node_modules/,
      },
      {
        test: /\.css$/i,
        use: ['style-loader', 'css-loader'],
      },
    ],
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: './src/index.html',
    }),
  ],
  devServer: {
    static: './dist',
    port: 3000,
    hot: true,
    open: true,
    host: '0.0.0.0', // Important for Gitpod
    allowedHosts: 'all',
  },
};
EOF
    print_success "Webpack configuration created"
fi

# Create TypeScript configuration if it doesn't exist
if [ ! -f "tsconfig.json" ]; then
    print_step "Creating TypeScript configuration..."
    cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "moduleResolution": "node",
    "allowSyntheticDefaultImports": true,
    "esModuleInterop": true,
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "declaration": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": false,
    "jsx": "react-jsx"
  },
  "include": [
    "src/**/*",
    "*.ts",
    "*.tsx"
  ],
  "exclude": [
    "node_modules",
    "dist",
    "**/*.test.ts",
    "**/*.spec.ts"
  ]
}
EOF
    print_success "TypeScript configuration created"
fi

# Create basic source files if they don't exist
if [ ! -d "src" ]; then
    print_step "Creating basic source files..."
    mkdir -p src
    
    cat > src/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>TypeScript Excel Add-in</title>
    <script src="https://appsforoffice.microsoft.com/lib/1/hosted/office.js"></script>
</head>
<body>
    <div id="content">
        <h1>TypeScript Excel Add-in</h1>
        <p>Welcome to your Gitpod development environment!</p>
        <button id="run">Run Excel Function</button>
        <div id="result"></div>
    </div>
    <script src="bundle.js"></script>
</body>
</html>
EOF

    cat > src/index.ts << 'EOF'
// Initialize Office.js
Office.onReady((info) => {
    console.log('Office.js is ready!');
    console.log('Host:', info.host);
    console.log('Platform:', info.platform);
    
    if (info.host === Office.HostType.Excel) {
        document.getElementById('run')?.addEventListener('click', run);
        console.log('Excel Add-in initialized successfully');
    } else {
        console.log('This add-in is designed for Excel');
        document.getElementById('result')!.innerHTML = 
            '<p style="color: orange;">This add-in is designed for Excel. Please open in Excel to use all features.</p>';
    }
});

async function run() {
    try {
        console.log('Running Excel function...');
        
        await Excel.run(async (context) => {
            const range = context.workbook.getSelectedRange();
            range.format.fill.color = 'yellow';
            range.values = [['Hello from TypeScript Excel Add-in!']];
            await context.sync();
        });
        
        document.getElementById('result')!.innerHTML = 
            '<p style="color: green;">✅ Excel function executed successfully!</p>';
    } catch (error) {
        console.error('Error:', error);
        document.getElementById('result')!.innerHTML = 
            `<p style="color: red;">❌ Error: ${error.message}</p>`;
    }
}
EOF
    print_success "Basic source files created"
fi

# Display workspace information
print_header "Workspace Information"

if [ -n "$GITPOD_WORKSPACE_ID" ]; then
    echo "🌐 Your development server will be available at:"
    echo "   - Main dev server: https://3000-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
    echo "   - Office Add-in: https://8080-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
    echo ""
fi

echo "🎯 To start developing:"
echo "   1. Run: npm run dev-server"
echo "   2. Open the preview URL in your browser"
echo "   3. Start coding your Excel Add-in!"
echo ""

echo "📁 Available projects:"
if [ -d "projects" ]; then
    ls -la projects/
else
    echo "   No projects found. Create one with: ./scripts/setup-project.sh my-project"
fi

echo ""
echo "🛠️ Available commands:"
echo "   - npm run dev-server    # Start development server"
echo "   - npm run build         # Build for production"
echo "   - npm test              # Run tests"
echo "   - npm run lint          # Run ESLint"
echo "   - npm run format        # Format code with Prettier"

print_success "Gitpod setup complete!"
print_status "Happy coding with TypeScript and Excel! 🚀"
