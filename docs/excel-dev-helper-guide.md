# Excel Development Helper Script Guide

## Overview

The `excel-dev-helper.sh` script is a comprehensive command-line tool designed to streamline TypeScript Excel Add-in development. It provides an interactive menu system and command-line interface for managing projects, running development servers, and configuring your environment.

## Location

```bash
./scripts/excel-dev-helper.sh
```

## Features

- ✅ Interactive menu system
- ✅ Project creation and management
- ✅ Development server control
- ✅ Build automation
- ✅ Test execution
- ✅ Environment setup and validation
- ✅ Node.js installation helper
- ✅ Global tools installation

## Prerequisites

The script will check for:
- **Node.js 20+** (can be installed via the script)
- **npm** (comes with Node.js)
- **Git** (required)

## Usage

### Interactive Mode

Run without arguments to launch the interactive menu:

```bash
./scripts/excel-dev-helper.sh
```

This displays a menu with options:
1. Create New Project
2. List Projects
3. Start Dev Server
4. Build Project
5. Run Tests
6. Install Node.js
7. Install Global Tools
8. Environment Info
9. Quick Start Guide
0. Exit

### Command-Line Mode

#### Install Node.js

```bash
./scripts/excel-dev-helper.sh install-node
```

Installs Node.js 20 from NodeSource repository.

#### Create a New Project

```bash
./scripts/excel-dev-helper.sh create my-excel-app
```

Or use aliases:
```bash
./scripts/excel-dev-helper.sh new my-excel-app
```

Creates a new Excel Add-in project with:
- Complete directory structure
- TypeScript configuration
- Webpack setup
- Jest testing framework
- ESLint and Prettier
- Sample Office.js code

#### List Projects

```bash
./scripts/excel-dev-helper.sh list
```

Or use alias:
```bash
./scripts/excel-dev-helper.sh ls
```

Shows all projects in the `./projects/` directory with descriptions.

#### Start Development Server

```bash
./scripts/excel-dev-helper.sh start my-excel-app
```

Or use aliases:
```bash
./scripts/excel-dev-helper.sh dev my-excel-app
./scripts/excel-dev-helper.sh serve my-excel-app
```

Starts the Webpack dev server on port 3000 with hot module reloading.

#### Build Project

```bash
# Production build
./scripts/excel-dev-helper.sh build my-excel-app

# Development build
./scripts/excel-dev-helper.sh build my-excel-app development
```

Builds the project to the `dist/` directory.

#### Run Tests

```bash
./scripts/excel-dev-helper.sh test my-excel-app
```

Runs Jest tests for the specified project.

#### Install Global Tools

```bash
./scripts/excel-dev-helper.sh install
```

Or use alias:
```bash
./scripts/excel-dev-helper.sh tools
```

Installs global npm packages:
- TypeScript
- ts-node
- Webpack & Webpack CLI
- Office.js development tools

#### Environment Information

```bash
./scripts/excel-dev-helper.sh info
```

Or use alias:
```bash
./scripts/excel-dev-helper.sh env
```

Displays:
- Node.js version
- npm version
- Git version
- TypeScript version
- Working directory
- Gitpod status (if applicable)

#### Quick Start Guide

```bash
./scripts/excel-dev-helper.sh help
```

Or use alias:
```bash
./scripts/excel-dev-helper.sh guide
```

Shows a quick reference guide.

## Workflow Examples

### Complete Setup from Scratch

```bash
# 1. Install Node.js (if not already installed)
./scripts/excel-dev-helper.sh install-node

# 2. Install global development tools
./scripts/excel-dev-helper.sh install

# 3. Create a new project
./scripts/excel-dev-helper.sh create my-first-addin

# 4. Start development
./scripts/excel-dev-helper.sh start my-first-addin
```

### Daily Development Workflow

```bash
# List available projects
./scripts/excel-dev-helper.sh list

# Start working on a project
./scripts/excel-dev-helper.sh start my-excel-app

# In another terminal, run tests
./scripts/excel-dev-helper.sh test my-excel-app

# Build for production
./scripts/excel-dev-helper.sh build my-excel-app
```

### Using Interactive Mode

```bash
# Launch interactive menu
./scripts/excel-dev-helper.sh

# Follow prompts to:
# - Create projects
# - Start servers
# - Run builds
# - Execute tests
```

## Project Structure Created

When you create a new project, the script generates:

```
projects/my-excel-app/
├── src/
│   ├── index.ts          # Main TypeScript entry point
│   ├── index.html        # HTML template
│   ├── components/       # UI components
│   ├── utils/            # Utility functions
│   ├── types/            # TypeScript type definitions
│   └── services/         # Business logic
├── tests/                # Jest test files
├── assets/               # Static resources
│   ├── images/
│   ├── icons/
│   └── css/
├── docs/                 # Project documentation
├── dist/                 # Build output (generated)
├── package.json          # Dependencies and scripts
├── tsconfig.json         # TypeScript configuration
├── webpack.config.js     # Webpack configuration
├── jest.config.js        # Jest configuration
├── .eslintrc.js          # ESLint rules
├── .prettierrc           # Prettier configuration
└── README.md             # Project documentation
```

## npm Scripts Available in Projects

Once inside a project directory, you can use:

```bash
npm run dev-server    # Start dev server with hot reload
npm run build         # Production build
npm run build:dev     # Development build
npm start             # Start development server
npm test              # Run tests
npm run test:watch    # Run tests in watch mode
npm run test:coverage # Run tests with coverage report
npm run lint          # Check code quality
npm run lint:fix      # Fix ESLint issues
npm run format        # Format code with Prettier
npm run validate      # Validate Office Add-in manifest
npm run sideload      # Sideload Add-in to Excel
```

## Environment Variables

The script respects:
- `GITPOD_WORKSPACE_ID` - Detects Gitpod environment
- `GITPOD_WORKSPACE_URL` - Shows Gitpod workspace URL

## Troubleshooting

### Node.js Not Found

If you see "Node.js not found":
```bash
./scripts/excel-dev-helper.sh install-node
```

### Permission Denied

If you get permission errors:
```bash
chmod +x ./scripts/excel-dev-helper.sh
```

### npm Install Fails

If global tool installation fails:
```bash
# Try with sudo (if not in container)
sudo npm install -g typescript webpack webpack-cli

# Or use the script's install function
./scripts/excel-dev-helper.sh install
```

### Port Already in Use

If port 3000 is already in use:
1. Stop the existing server
2. Or modify `webpack.config.js` in your project to use a different port

### Project Not Found

Ensure you're in the repository root:
```bash
cd /workspaces/typescript-excel-devcontainer
./scripts/excel-dev-helper.sh list
```

## Tips and Best Practices

1. **Use Interactive Mode for Exploration**: When learning, use the interactive menu to discover features.

2. **Use Command-Line Mode for Automation**: In scripts or CI/CD, use direct commands.

3. **Check Environment First**: Run `./scripts/excel-dev-helper.sh info` to verify your setup.

4. **Install Global Tools Once**: After installing Node.js, run the global tools installer once per environment.

5. **Keep Projects Organized**: All projects live in `./projects/` directory.

6. **Use Descriptive Names**: Project names should be lowercase with hyphens (e.g., `my-excel-calculator`).

## Integration with Other Scripts

The helper script works alongside existing scripts:

- `setup-project.sh` - Called internally by the helper
- `build-all.sh` - Build all projects at once
- `test-all.sh` - Test all projects at once
- `gitpod-setup.sh` - Gitpod environment initialization

## Advanced Usage

### Custom Build Modes

```bash
# Production build (default)
./scripts/excel-dev-helper.sh build my-app

# Development build (with source maps)
./scripts/excel-dev-helper.sh build my-app development
```

### Batch Operations

```bash
# Create multiple projects
for name in calculator converter analyzer; do
    ./scripts/excel-dev-helper.sh create excel-$name
done

# Build all projects
cd projects
for dir in */; do
    cd "$dir"
    npm run build
    cd ..
done
```

### Scripting with the Helper

```bash
#!/bin/bash
# Example: Automated project setup

./scripts/excel-dev-helper.sh create my-new-app
cd projects/my-new-app
npm install
npm run build
npm test
```

## Support

For issues or questions:
1. Check the troubleshooting section
2. Review the main README.md
3. Check docs/troubleshooting.md
4. Open an issue in the repository

## Related Documentation

- [Getting Started Guide](getting-started.md)
- [Gitpod Setup Guide](gitpod-setup-guide.md)
- [DevContainer Usage Guide](devcontainer-usage-guide.md)
- [Troubleshooting Guide](troubleshooting.md)

---

**Happy Excel Add-in Development! 🚀**
