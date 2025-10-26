# Scripts Directory

This directory contains utility scripts for managing your TypeScript Excel development environment.

## 📜 Available Scripts

### 🌟 Excel Development Helper (NEW!)

**`excel-dev-helper.sh`** - Comprehensive interactive tool for Excel Add-in development

**Quick Start:**
```bash
# Interactive menu
./scripts/excel-dev-helper.sh

# Create project
./scripts/excel-dev-helper.sh create my-excel-app

# Start dev server
./scripts/excel-dev-helper.sh start my-excel-app
```

**Features:**
- ✅ Interactive menu system
- ✅ Project creation and management
- ✅ Development server control
- ✅ Build automation
- ✅ Test execution
- ✅ Node.js installation
- ✅ Environment validation

**Documentation:**
- [Excel Dev Quick Start](../EXCEL_DEV_QUICKSTART.md)
- [Complete Guide](../docs/excel-dev-helper-guide.md)
- [Demo & Examples](../SCRIPT_DEMO.md)

---

### Project Management

**`setup-project.sh`** - Create new Excel Add-in projects
```bash
./scripts/setup-project.sh my-project-name
```

**`build-all.sh`** - Build all projects in the projects/ directory
```bash
./scripts/build-all.sh
```

**`test-all.sh`** - Run tests for all projects
```bash
./scripts/test-all.sh
```

---

### Gitpod Environment

**`gitpod-setup.sh`** - Initialize Gitpod development environment
```bash
./scripts/gitpod-setup.sh
```

**`gitpod-test.sh`** - Test Gitpod configuration
```bash
./scripts/gitpod-test.sh
```

**`setup-gitpod-workspace.sh`** - Complete Gitpod workspace setup
```bash
./scripts/setup-gitpod-workspace.sh
```

**`setup-gitpod-windows.sh`** - Gitpod setup for Windows 11 + WSL2
```bash
./scripts/setup-gitpod-windows.sh
```

**`quick-start-gitpod.sh`** - Quick Gitpod initialization
```bash
./scripts/quick-start-gitpod.sh
```

---

### Configuration

**`configure-user-info.sh`** - Configure Git user information
```bash
./scripts/configure-user-info.sh
```

**`setup-repository.sh`** - Initialize repository settings
```bash
./scripts/setup-repository.sh
```

---

### Development Container

**`open-devcontainer.sh`** - Open project in VS Code Dev Container
```bash
./scripts/open-devcontainer.sh
```

---

### Maintenance

**`cleanup-for-publish.sh`** - Clean up repository for publishing
```bash
./scripts/cleanup-for-publish.sh
```

---

## 🎯 Recommended Workflow

### First Time Setup

1. **Install Node.js** (if needed)
   ```bash
   ./scripts/excel-dev-helper.sh install-node
   ```

2. **Install global tools**
   ```bash
   ./scripts/excel-dev-helper.sh install
   ```

3. **Verify environment**
   ```bash
   ./scripts/excel-dev-helper.sh info
   ```

### Daily Development

1. **Create or select project**
   ```bash
   ./scripts/excel-dev-helper.sh list
   ./scripts/excel-dev-helper.sh create my-new-app
   ```

2. **Start development**
   ```bash
   ./scripts/excel-dev-helper.sh start my-app
   ```

3. **Build and test**
   ```bash
   ./scripts/excel-dev-helper.sh test my-app
   ./scripts/excel-dev-helper.sh build my-app
   ```

---

## 📚 Documentation

- [Main README](../README.md)
- [Quick Start Guide](../QUICK_START.md)
- [Excel Dev Quick Start](../EXCEL_DEV_QUICKSTART.md)
- [Getting Started](../docs/getting-started.md)
- [Troubleshooting](../docs/troubleshooting.md)

---

## 💡 Tips

1. **Use the helper script** - It's the easiest way to manage projects
2. **Check prerequisites first** - Run `excel-dev-helper.sh info`
3. **Use interactive mode** - Great for learning and exploration
4. **Use direct commands** - Faster once you know what you need
5. **Read the docs** - Comprehensive guides available

---

## 🆘 Getting Help

```bash
# Show quick start guide
./scripts/excel-dev-helper.sh help

# Show environment info
./scripts/excel-dev-helper.sh info

# Launch interactive menu
./scripts/excel-dev-helper.sh
```

---

**Happy Excel Add-in Development! 🚀**
