#!/bin/bash

# Setup Project Script
# This script helps set up a new TypeScript Excel project

set -e

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

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    if ! command_exists node; then
        print_error "Node.js is not installed. Please install Node.js first."
        exit 1
    fi
    
    if ! command_exists npm; then
        print_error "npm is not installed. Please install npm first."
        exit 1
    fi
    
    if ! command_exists git; then
        print_error "Git is not installed. Please install Git first."
        exit 1
    fi
    
    print_success "All prerequisites are installed."
}

# Function to create project structure
create_project_structure() {
    local project_name=$1
    local project_path="./projects/$project_name"
    
    print_status "Creating project structure for $project_name..."
    
    # Create projects directory if it doesn't exist
    mkdir -p "./projects"
    
    # Create project directory
    mkdir -p "$project_path"
    
    # Create directory structure
    mkdir -p "$project_path/src/components"
    mkdir -p "$project_path/src/utils"
    mkdir -p "$project_path/src/types"
    mkdir -p "$project_path/src/services"
    mkdir -p "$project_path/tests"
    mkdir -p "$project_path/docs"
    mkdir -p "$project_path/assets/images"
    mkdir -p "$project_path/assets/icons"
    mkdir -p "$project_path/assets/css"
    
    # Remove any nested projects directory that might have been created
    if [ -d "$project_path/projects" ]; then
        rm -rf "$project_path/projects"
    fi
    
    print_success "Project structure created."
}

# Function to initialize package.json
init_package_json() {
    local project_name=$1
    local project_path="./projects/$project_name"
    
    print_status "Initializing package.json..."
    
    cd "$project_path"
    
    # Create package.json
    cat > package.json << EOF
{
  "name": "$project_name",
  "version": "1.0.0",
  "description": "TypeScript Excel Add-in",
  "main": "dist/index.js",
  "scripts": {
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
    "dev-server": "webpack serve --mode development --open"
  },
  "keywords": ["excel", "add-in", "typescript", "office-js"],
  "author": "FireZombieCoder",
  "license": "MIT",
  "dependencies": {
    "@microsoft/office-js": "^1.1.110",
    "@microsoft/office-js-helpers": "^1.0.2"
  },
  "devDependencies": {
    "@types/office-js": "^1.0.0",
    "@types/office-runtime": "^1.0.0",
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
    "ts-jest": "^29.0.0"
  }
}
EOF
    
    print_success "package.json created."
}

# Function to copy configuration files
copy_config_files() {
    local project_path=$1
    
    print_status "Copying configuration files..."
    
    # Copy TypeScript configuration
    if [ -f "DevContainer/tsconfig.json" ]; then
        cp DevContainer/tsconfig.json "$project_path/"
        print_success "tsconfig.json copied."
    else
        print_warning "tsconfig.json not found in DevContainer directory."
    fi
    
    # Copy webpack configuration
    if [ -f "DevContainer/webpack.config.js" ]; then
        cp DevContainer/webpack.config.js "$project_path/"
        print_success "webpack.config.js copied."
    else
        print_warning "webpack.config.js not found in DevContainer directory."
    fi
    
    # Copy ESLint configuration
    if [ -f "DevContainer/.eslintrc.js" ]; then
        cp DevContainer/.eslintrc.js "$project_path/"
        print_success ".eslintrc.js copied."
    else
        print_warning ".eslintrc.js not found in DevContainer directory."
    fi
    
    # Copy Prettier configuration
    if [ -f "DevContainer/.prettierrc" ]; then
        cp DevContainer/.prettierrc "$project_path/"
        print_success ".prettierrc copied."
    else
        print_warning ".prettierrc not found in DevContainer directory."
    fi
    
    # Copy Jest configuration
    if [ -f "DevContainer/jest.config.js" ]; then
        cp DevContainer/jest.config.js "$project_path/"
        print_success "jest.config.js copied."
    else
        print_warning "jest.config.js not found in DevContainer directory."
    fi
}

# Function to create basic source files
create_source_files() {
    local project_path=$1
    
    print_status "Creating basic source files..."
    
    # Ensure all directories exist
    mkdir -p "$project_path/src"
    mkdir -p "$project_path/src/types"
    mkdir -p "$project_path/src/utils"
    mkdir -p "$project_path/tests"
    
    # Create main HTML file
    cat > "$project_path/src/index.html" << 'EOF'
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
    
    # Create main TypeScript file
    cat > "$project_path/src/index.ts" << 'EOF'
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
    
    # Create types file
    cat > "$project_path/src/types/index.ts" << 'EOF'
// Type definitions for your Excel Add-in

export interface ExcelRange {
    address: string;
    values: any[][];
}

export interface ExcelWorksheet {
    name: string;
    ranges: ExcelRange[];
}

export interface ExcelWorkbook {
    worksheets: ExcelWorksheet[];
}
EOF
    
    # Create utils file
    cat > "$project_path/src/utils/index.ts" << 'EOF'
// Utility functions for your Excel Add-in

export function formatCellValue(value: any): string {
    if (typeof value === 'string') {
        return value;
    }
    if (typeof value === 'number') {
        return value.toString();
    }
    return JSON.stringify(value);
}

export function isValidRange(range: any): boolean {
    return range && typeof range === 'object' && 'address' in range;
}
EOF
    
    # Create basic test file
    cat > "$project_path/tests/index.test.ts" << 'EOF'
import { formatCellValue, isValidRange } from '../src/utils';

describe('Utility Functions', () => {
    test('formatCellValue should format string values', () => {
        expect(formatCellValue('hello')).toBe('hello');
    });
    
    test('formatCellValue should format number values', () => {
        expect(formatCellValue(123)).toBe('123');
    });
    
    test('isValidRange should validate range objects', () => {
        expect(isValidRange({ address: 'A1' })).toBe(true);
        expect(isValidRange(null)).toBe(false);
    });
});
EOF
    
    print_success "Basic source files created."
}

# Function to install dependencies
install_dependencies() {
    local project_path=$1
    
    print_status "Installing dependencies..."
    
    if (cd "$project_path" && npm install); then
        print_success "Dependencies installed successfully."
    else
        print_error "Failed to install dependencies."
        exit 1
    fi
}

# Function to create README
create_readme() {
    local project_name=$1
    local project_path="./projects/$project_name"
    
    print_status "Creating README.md..."
    
    cat > "$project_path/README.md" << EOF
# $project_name

A TypeScript Excel Add-in built with Office.js.

## Getting Started

1. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

2. Start development server:
   \`\`\`bash
   npm run dev-server
   \`\`\`

3. Build for production:
   \`\`\`bash
   npm run build
   \`\`\`

## Available Scripts

- \`npm run build\` - Build for production
- \`npm run build:dev\` - Build for development
- \`npm run start\` - Start development server
- \`npm test\` - Run tests
- \`npm run lint\` - Run ESLint
- \`npm run format\` - Format code with Prettier

## Project Structure

\`\`\`
src/
├── index.ts          # Main entry point
├── index.html        # HTML template
├── types/            # Type definitions
├── utils/            # Utility functions
└── components/       # React components (if using)
\`\`\`

## Development

This project uses:
- TypeScript for type safety
- Webpack for bundling
- Jest for testing
- ESLint for code quality
- Prettier for code formatting

## License

MIT
EOF
    
    print_success "README.md created."
}

# Main function
main() {
    local project_name=$1
    
    if [ -z "$project_name" ]; then
        print_error "Please provide a project name."
        echo "Usage: $0 <project-name>"
        exit 1
    fi
    
    print_status "Setting up project: $project_name"
    
    # Check prerequisites
    check_prerequisites
    
    # Create project structure
    create_project_structure "$project_name"
    
    # Initialize package.json
    init_package_json "$project_name"
    
    # Copy configuration files
    copy_config_files "./projects/$project_name"
    
    # Create source files
    create_source_files "./projects/$project_name"
    
    # Install dependencies
    install_dependencies "./projects/$project_name"
    
    # Create README
    create_readme "$project_name" "./projects/$project_name"
    
    print_success "Project setup complete!"
    print_status "To start developing:"
    print_status "  cd ./projects/$project_name"
    print_status "  npm run dev-server"
    print_status ""
    print_status "Note: For full Office.js functionality, use this devcontainer in VS Code:"
    print_status "  1. Open the DevContainer folder in VS Code"
    print_status "  2. Click 'Reopen in Container' when prompted"
    print_status "  3. Your project will be available in /workspaces/projects/$project_name"
}

# Run main function with all arguments
main "$@"
