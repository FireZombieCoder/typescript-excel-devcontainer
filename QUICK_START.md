# 🚀 Quick Start Guide

## TypeScript Excel Development Environment

This guide will help you get started with TypeScript Excel development using either **Gitpod** (cloud) or **WSL2** (local).

---

## 🌐 Option 1: Gitpod (Cloud Development) - **RECOMMENDED**

### **One-Click Setup**

**Click this link to open your workspace immediately:**
👉 **[https://gitpod.io/#https://github.com/FireZombieCoder/typescript-excel-devcontainer](https://gitpod.io/#https://github.com/FireZombieCoder/typescript-excel-devcontainer)**

### **What happens when you open Gitpod:**
1. **Automatic Setup**: The workspace will automatically configure itself
2. **Dependencies Installed**: All TypeScript, Office.js, and development tools
3. **VS Code Ready**: Pre-configured with all necessary extensions
4. **Port Forwarding**: Your app will be available at preview URLs

### **Start Developing in Gitpod:**
```bash
# The workspace will automatically set up, then run:
npm run dev-server

# Your app will be available at:
# https://3000-[workspace-id].gitpod.io
```

---

## 💻 Option 2: WSL2 (Local Development)

### **Prerequisites**
- Windows 11 with WSL2
- VS Code with Dev Containers extension
- Docker Desktop

### **Setup Steps**

1. **Open in VS Code:**
   ```bash
   # In WSL2 terminal:
   code DevContainer
   ```

2. **Reopen in Container:**
   - VS Code will prompt "Reopen in Container"
   - Click "Reopen in Container"
   - Wait for the container to build (2-3 minutes)

3. **Start Developing:**
   ```bash
   npm run dev-server
   ```

---

## 🛠️ Development Commands

### **Basic Commands**
```bash
npm run dev-server    # Start development server
npm run build         # Build for production
npm test              # Run tests
npm run lint          # Run ESLint
npm run format        # Format code with Prettier
```

### **Project Management**
```bash
# Create a new Excel Add-in project
./scripts/setup-project.sh my-excel-addin

# Build all projects
./scripts/build-all.sh

# Test all projects
./scripts/test-all.sh
```

### **Office Add-in Specific**
```bash
npm run validate      # Validate Add-in manifest
npm run sideload      # Sideload Add-in to Excel
```

---

## 📁 Project Structure

```
DevContainer/
├── .gitpod.yml           # Gitpod configuration
├── .gitpod.Dockerfile    # Gitpod Docker image
├── devcontainer.json     # VS Code devcontainer config
└── Dockerfile            # Local development container

projects/                 # Your Excel Add-in projects
├── my-excel-project/     # Example project
└── [your-projects]/      # Your custom projects

templates/                # Project templates
├── excel-addin-basic/    # Basic Excel Add-in
├── excel-function-builder/ # Function builder
└── excel-game/           # Excel game

scripts/                  # Utility scripts
├── setup-project.sh      # Create new project
├── gitpod-setup.sh       # Gitpod environment setup
└── setup-gitpod-workspace.sh # Complete Gitpod setup
```

---

## 🎯 Creating Your First Excel Add-in

### **1. Create a New Project**
```bash
./scripts/setup-project.sh my-first-addin
cd projects/my-first-addin
```

### **2. Start Development**
```bash
npm run dev-server
```

### **3. Open in Excel**
- Open Excel Online or Excel Desktop
- Go to Insert → Add-ins → Upload My Add-in
- Upload your manifest.xml file

---

## 🔧 Configuration

### **Git Configuration**
```bash
git config --global user.name "FireZombieCoder"
git config --global user.email "firezombify@gmail.com"
```

### **VS Code Extensions** (Auto-installed in Gitpod)
- TypeScript and JavaScript support
- Office.js development tools
- ESLint and Prettier
- Git integration
- Testing frameworks

---

## 📚 Resources

### **Documentation**
- [Gitpod Setup Guide](docs/gitpod-setup-guide.md)
- [DevContainer Usage Guide](docs/devcontainer-usage-guide.md)
- [Troubleshooting Guide](docs/troubleshooting.md)

### **External Resources**
- [Office.js Documentation](https://docs.microsoft.com/en-us/office/dev/add-ins/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Gitpod Documentation](https://www.gitpod.io/docs)

---

## 🆘 Troubleshooting

### **Common Issues**

**Gitpod not loading:**
- Check internet connection
- Verify GitHub repository access
- Try refreshing the workspace

**Office.js not working:**
- Ensure you're using HTTPS
- Check manifest.xml configuration
- Verify Office.js CDN accessibility

**Build failures:**
- Run `npm install` to install dependencies
- Check for TypeScript errors
- Verify all required files are present

### **Getting Help**
- Check the troubleshooting guide
- Review the Office.js documentation
- Open an issue in the repository

---

## 🎉 Ready to Start!

**Choose your preferred development method:**

### **🌐 Gitpod (Cloud)**
👉 **[Open in Gitpod Now](https://gitpod.io/#https://github.com/FireZombieCoder/typescript-excel-devcontainer)**

### **💻 WSL2 (Local)**
```bash
code DevContainer
# Click "Reopen in Container" when prompted
```

**Happy coding with TypeScript and Excel! 🚀**
