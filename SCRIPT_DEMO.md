# Excel Development Helper Script - Demo

## 🎬 Visual Walkthrough

This document shows what the helper script looks like in action.

---

## 📋 Command: List Projects

```bash
./scripts/excel-dev-helper.sh list
```

**Output:**
```
╔════════════════════════════════════════════════════════════╗
║  Available Projects
╚════════════════════════════════════════════════════════════╝

[1] my-excel-project
    → TypeScript Excel Add-in
```

---

## ℹ️ Command: Environment Info

```bash
./scripts/excel-dev-helper.sh info
```

**Output:**
```
[INFO] Checking prerequisites...
[!] Node.js not found
[!] npm not found
[✓] Git 2.51.1
[!] Node.js is required for Excel development

To install Node.js:
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
  sudo apt-get install -y nodejs

Or run: ./scripts/excel-dev-helper.sh install-node

╔════════════════════════════════════════════════════════════╗
║  Development Environment Information
╚════════════════════════════════════════════════════════════╝

Node.js: 
npm: 
Git: 2.51.1
TypeScript: Not installed globally

Working Directory: /workspaces/typescript-excel-devcontainer
Projects Directory: ./projects/
```

---

## 📖 Command: Help Guide

```bash
./scripts/excel-dev-helper.sh help
```

**Output:**
```
╔════════════════════════════════════════════════════════════╗
║  Quick Start Guide
╚════════════════════════════════════════════════════════════╝

1. Create a new project:
   ./scripts/excel-dev-helper.sh create my-excel-app

2. Start development server:
   ./scripts/excel-dev-helper.sh start my-excel-app

3. Build for production:
   ./scripts/excel-dev-helper.sh build my-excel-app

4. Run tests:
   ./scripts/excel-dev-helper.sh test my-excel-app

5. Interactive menu:
   ./scripts/excel-dev-helper.sh

Common npm commands (inside project directory):
  npm run dev-server    - Start dev server with hot reload
  npm run build         - Production build
  npm run build:dev     - Development build
  npm test              - Run tests
  npm run lint          - Check code quality
  npm run format        - Format code
```

---

## 🎯 Interactive Menu

```bash
./scripts/excel-dev-helper.sh
```

**Output:**
```
[INFO] Checking prerequisites...
[!] Node.js not found
[!] npm not found
[✓] Git 2.51.1
[!] Node.js is required for Excel development

To install Node.js:
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
  sudo apt-get install -y nodejs

Or run: ./scripts/excel-dev-helper.sh install-node

╔════════════════════════════════════════════════════════════╗
║  TypeScript Excel Development Helper
╚════════════════════════════════════════════════════════════╝

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

Select option [0-9]: _
```

---

## 🔧 Command: Install Node.js

```bash
./scripts/excel-dev-helper.sh install-node
```

**Expected Output:**
```
[INFO] Checking prerequisites...
[!] Node.js not found
[!] npm not found
[✓] Git 2.51.1

╔════════════════════════════════════════════════════════════╗
║  Installing Node.js 20
╚════════════════════════════════════════════════════════════╝

[INFO] Adding NodeSource repository...
[INFO] Installing Node.js...
[✓] Node.js installed: v20.x.x
[✓] npm installed: 10.x.x
```

---

## 🛠️ Command: Install Global Tools

```bash
./scripts/excel-dev-helper.sh install
```

**Expected Output:**
```
[INFO] Checking prerequisites...
[✓] Node.js v20.x.x
[✓] npm 10.x.x
[✓] Git 2.51.1
[✓] All prerequisites satisfied

╔════════════════════════════════════════════════════════════╗
║  Installing Global TypeScript Tools
╚════════════════════════════════════════════════════════════╝

[INFO] Installing TypeScript and build tools...
[INFO] Installing Office.js development tools...
[✓] Global tools installed
```

---

## 📦 Command: Create New Project

```bash
./scripts/excel-dev-helper.sh create my-excel-calculator
```

**Expected Output:**
```
[INFO] Checking prerequisites...
[✓] Node.js v20.x.x
[✓] npm 10.x.x
[✓] Git 2.51.1
[✓] All prerequisites satisfied

╔════════════════════════════════════════════════════════════╗
║  Creating Project: my-excel-calculator
╚════════════════════════════════════════════════════════════╝

[INFO] Setting up project: my-excel-calculator
[INFO] Checking prerequisites...
[✓] All prerequisites are installed.
[INFO] Creating project structure for my-excel-calculator...
[✓] Project structure created.
[INFO] Initializing package.json...
[✓] package.json created.
[INFO] Copying configuration files...
[✓] tsconfig.json copied.
[✓] webpack.config.js copied.
[✓] jest.config.js copied.
[✓] .prettierrc copied.
[INFO] Creating basic source files...
[✓] Basic source files created.
[INFO] Installing dependencies...
[✓] Dependencies installed successfully.
[INFO] Creating README.md...
[✓] README.md created.
[✓] Project setup complete!
[INFO] To start developing:
[INFO]   cd ./projects/my-excel-calculator
[INFO]   npm run dev-server

[✓] Project created at: ./projects/my-excel-calculator
```

---

## 🚀 Command: Start Dev Server

```bash
./scripts/excel-dev-helper.sh start my-excel-calculator
```

**Expected Output:**
```
[INFO] Checking prerequisites...
[✓] Node.js v20.x.x
[✓] npm 10.x.x
[✓] Git 2.51.1
[✓] All prerequisites satisfied

╔════════════════════════════════════════════════════════════╗
║  Starting Dev Server: my-excel-calculator
╚════════════════════════════════════════════════════════════╝

[✓] Starting development server on port 3000...

> my-excel-calculator@1.0.0 dev-server
> webpack serve --mode development --open

<i> [webpack-dev-server] Project is running at:
<i> [webpack-dev-server] Loopback: http://localhost:3000/
<i> [webpack-dev-server] On Your Network (IPv4): http://172.x.x.x:3000/
<i> [webpack-dev-server] Content not from webpack is served from './dist' directory
asset bundle.js 1.2 MiB [emitted] (name: main)
webpack 5.x.x compiled successfully in 1234 ms
```

---

## 🏗️ Command: Build Project

```bash
./scripts/excel-dev-helper.sh build my-excel-calculator
```

**Expected Output:**
```
[INFO] Checking prerequisites...
[✓] Node.js v20.x.x
[✓] npm 10.x.x
[✓] Git 2.51.1
[✓] All prerequisites satisfied

╔════════════════════════════════════════════════════════════╗
║  Building Project: my-excel-calculator (production)
╚════════════════════════════════════════════════════════════╝

> my-excel-calculator@1.0.0 build
> webpack --mode production

asset bundle.js 234 KiB [emitted] [minimized] (name: main)
webpack 5.x.x compiled successfully in 2345 ms

[✓] Build complete: ./projects/my-excel-calculator/dist/
```

---

## 🧪 Command: Run Tests

```bash
./scripts/excel-dev-helper.sh test my-excel-calculator
```

**Expected Output:**
```
[INFO] Checking prerequisites...
[✓] Node.js v20.x.x
[✓] npm 10.x.x
[✓] Git 2.51.1
[✓] All prerequisites satisfied

╔════════════════════════════════════════════════════════════╗
║  Running Tests: my-excel-calculator
╚════════════════════════════════════════════════════════════╝

> my-excel-calculator@1.0.0 test
> jest

 PASS  tests/index.test.ts
  Utility Functions
    ✓ formatCellValue should format string values (2 ms)
    ✓ formatCellValue should format number values (1 ms)
    ✓ isValidRange should validate range objects (1 ms)

Test Suites: 1 passed, 1 total
Tests:       3 passed, 3 total
Snapshots:   0 total
Time:        1.234 s
Ran all test suites.
```

---

## 🎨 Color Legend

The script uses colors for clarity:

- **[INFO]** - Blue - Informational messages
- **[✓]** - Green - Success messages
- **[!]** - Yellow - Warnings
- **[✗]** - Red - Error messages
- **Headers** - Purple - Section headers
- **Options** - Cyan - Menu options and highlights

---

## 💡 Tips for Using the Script

### 1. Start with Info Command
```bash
./scripts/excel-dev-helper.sh info
```
Check your environment before doing anything else.

### 2. Use Interactive Mode for Learning
```bash
./scripts/excel-dev-helper.sh
```
The menu helps you discover all available options.

### 3. Use Direct Commands for Speed
```bash
./scripts/excel-dev-helper.sh start my-app
```
Once you know what you need, direct commands are faster.

### 4. Check the List Regularly
```bash
./scripts/excel-dev-helper.sh list
```
See all your projects and their descriptions.

### 5. Read Help When Stuck
```bash
./scripts/excel-dev-helper.sh help
```
Quick reference for common commands.

---

## 🔗 Related Documentation

- [EXCEL_DEV_QUICKSTART.md](EXCEL_DEV_QUICKSTART.md) - Quick start guide
- [docs/excel-dev-helper-guide.md](docs/excel-dev-helper-guide.md) - Complete documentation
- [HELPER_SCRIPT_SUMMARY.md](HELPER_SCRIPT_SUMMARY.md) - Feature summary

---

**Ready to start building Excel Add-ins! 🚀**
