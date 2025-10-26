# Gitpod Setup Guide for Windows 11 with WSL2

This comprehensive guide will help you set up Gitpod for TypeScript Excel development with Office Add-ins on Windows 11 using WSL2.

## 🚀 Quick Start

### Prerequisites

#### Windows 11 Requirements
- Windows 11 (Build 22000 or later)
- WSL2 installed and configured
- Git for Windows
- A Gitpod account (free at [gitpod.io](https://gitpod.io))

#### WSL2 Setup
1. Open PowerShell as Administrator
2. Run: `wsl --install`
3. Restart your computer
4. Set WSL2 as default: `wsl --set-default-version 2`

### One-Command Setup

```bash
# Clone the repository
git clone <your-repository-url>
cd Devcontainers

# Run the setup script
./scripts/setup-gitpod-windows.sh

# Open in Gitpod
# 1. Push your changes to GitHub
# 2. Go to https://gitpod.io
# 3. Open your repository in Gitpod
```

## 📋 Detailed Setup Instructions

### Step 1: Windows 11 and WSL2 Setup

#### Enable WSL2
```powershell
# Run in PowerShell as Administrator
wsl --install
wsl --set-default-version 2
```

#### Verify WSL2 Installation
```bash
wsl --list --verbose
# Should show your distribution with version 2
```

#### Install Git for Windows
1. Download from [git-scm.com](https://git-scm.com/download/win)
2. Install with default settings
3. Verify installation: `git --version`

### Step 2: Gitpod Account Setup

1. Go to [gitpod.io](https://gitpod.io)
2. Sign up with your GitHub account
3. Authorize Gitpod to access your repositories
4. Verify your account is active

### Step 3: Repository Setup

#### Clone and Configure
```bash
# Clone your repository
git clone <your-repository-url>
cd Devcontainers

# Run the setup script
./scripts/setup-gitpod-windows.sh

# Check the configuration
./scripts/setup-gitpod-windows.sh --test
```

#### Push to GitHub
```bash
git add .
git commit -m "Add Gitpod configuration for TypeScript Excel development"
git push origin main
```

### Step 4: Open in Gitpod

1. Go to [gitpod.io](https://gitpod.io)
2. Click "New Workspace"
3. Select your repository
4. Wait for the workspace to initialize (2-3 minutes)

## 🛠️ Gitpod Features

### Pre-configured Environment
- **Node.js 20**: Latest LTS version
- **TypeScript 5.0+**: Latest TypeScript with full Office.js support
- **Office.js SDK**: Complete SDK with TypeScript definitions
- **VS Code Extensions**: All necessary extensions pre-installed
- **Project Templates**: Ready-to-use Excel Add-in templates

### Port Forwarding
- **Port 3000**: Main development server
- **Port 8080**: Office Add-in testing and sideloading
- **Port 9229**: Chrome/Edge debugging port

### VS Code Extensions
- Office Add-in development tools
- TypeScript and JavaScript support
- ESLint and Prettier for code quality
- Git integration and GitHub support
- Testing frameworks (Jest, Playwright)
- Web development tools

## 🎯 Development Workflow

### Starting Development

1. **Open in Gitpod**: Your workspace will automatically set up
2. **Start Dev Server**: Run `npm run dev-server`
3. **Access Your App**: Click the preview URL in Gitpod
4. **Start Coding**: Begin developing your Excel Add-in

### Creating New Projects

```bash
# Create a new Excel Add-in project
./scripts/setup-project.sh my-excel-addin

# Navigate to your project
cd projects/my-excel-addin

# Start development
npm run dev-server
```

### Available Commands

```bash
# Development
npm run dev-server    # Start development server
npm run build         # Build for production
npm run build:dev     # Build for development

# Testing
npm test              # Run all tests
npm run test:watch    # Run tests in watch mode
npm run test:coverage # Run tests with coverage

# Code Quality
npm run lint          # Run ESLint
npm run lint:fix      # Fix ESLint issues
npm run format        # Format code with Prettier

# Office Add-in Specific
npm run validate      # Validate Add-in manifest
npm run sideload      # Sideload Add-in to Excel
```

## 📱 Office Add-in Development

### Sideloading Add-ins

#### Method 1: Using the Command Line
```bash
# Build your add-in
npm run build

# Sideload to Excel
npm run sideload
```

#### Method 2: Manual Sideloading
1. Build your add-in: `npm run build`
2. Create a `manifest.xml` file
3. In Excel, go to Insert > Add-ins > Upload My Add-in
4. Select your manifest file

### Testing in Excel Online

1. Start your dev server: `npm run dev-server`
2. Open Excel Online
3. Go to Insert > Add-ins > Upload My Add-in
4. Enter your manifest URL: `https://your-gitpod-url/manifest.xml`

### Testing in Excel Desktop

1. Ensure your add-in is accessible via HTTPS
2. Use the sideloading method above
3. Your add-in will appear in the Insert tab

## 🔧 Configuration Files

### .gitpod.yml
Main Gitpod configuration file containing:
- Docker image specification
- Port forwarding configuration
- VS Code extensions
- Environment variables
- Workspace tasks

### .gitpod.Dockerfile
Custom Docker image with:
- Node.js 20
- TypeScript toolchain
- Office.js development tools
- Pre-configured workspace

### package.json
Project configuration with:
- Gitpod-specific scripts
- Office.js dependencies
- Development tools
- Build and test configurations

## 🐛 Troubleshooting

### Common Issues

#### WSL2 Not Working
```bash
# Check WSL version
wsl --list --verbose

# Update WSL
wsl --update

# Set default version
wsl --set-default-version 2
```

#### Gitpod Connection Issues
- Check internet connectivity
- Verify Gitpod account status
- Try refreshing the workspace
- Check browser console for errors

#### Office.js Not Loading
- Ensure you're using HTTPS
- Check manifest.xml configuration
- Verify Office.js CDN accessibility
- Check browser console for errors

#### Build Failures
```bash
# Clear npm cache
npm cache clean --force

# Delete node_modules and reinstall
rm -rf node_modules package-lock.json
npm install

# Check for TypeScript errors
npx tsc --noEmit
```

#### Port Issues
- Check if ports are already in use
- Verify port forwarding in Gitpod
- Try different ports in webpack.config.js

### Getting Help

1. **Check Documentation**:
   - [Gitpod Documentation](https://www.gitpod.io/docs)
   - [Office.js Documentation](https://docs.microsoft.com/en-us/office/dev/add-ins/)
   - [TypeScript Handbook](https://www.typescriptlang.org/docs/)

2. **Community Support**:
   - [Gitpod Community](https://community.gitpod.io/)
   - [Office Add-ins Community](https://techcommunity.microsoft.com/t5/microsoft-365-developer/ct-p/Microsoft365Developer)

3. **Repository Issues**:
   - Open an issue in this repository
   - Check existing issues and solutions

## 🚀 Advanced Configuration

### Custom Docker Image

Edit `.gitpod.Dockerfile` to customize the environment:

```dockerfile
# Add custom packages
RUN apt-get update && apt-get install -y your-package

# Install additional Node.js packages
RUN npm install -g your-global-package
```

### Additional Ports

Add ports to `.gitpod.yml`:

```yaml
ports:
  - port: 3001
    onOpen: open-preview
    name: "Additional Service"
    description: "Custom service port"
```

### Environment Variables

Add to `.gitpod.yml`:

```yaml
env:
  - name: CUSTOM_VAR
    value: "custom-value"
  - name: API_KEY
    value: $API_KEY  # From Gitpod secrets
```

### Custom VS Code Settings

Add to `.gitpod.yml`:

```yaml
vscode:
  settings:
    editor.fontSize: 16
    editor.tabSize: 4
    typescript.preferences.importModuleSpecifier: "relative"
```

## 📚 Best Practices

### Development
1. **Use Prebuilds**: Enable prebuilds for faster workspace startup
2. **Pin Dependencies**: Use exact versions in package.json
3. **Optimize Images**: Keep Docker images small and efficient
4. **Regular Updates**: Keep dependencies and tools updated
5. **Use Workspace Settings**: Configure VS Code settings in .gitpod.yml

### Office Add-in Development
1. **Test in Multiple Environments**: Excel Online, Excel Desktop, Excel Mobile
2. **Use TypeScript**: Leverage type safety for better development experience
3. **Follow Office.js Patterns**: Use recommended patterns and best practices
4. **Handle Errors Gracefully**: Implement proper error handling
5. **Optimize Performance**: Use efficient Office.js APIs

### Gitpod Usage
1. **Use Workspace Snapshots**: Save your workspace state
2. **Share Workspaces**: Collaborate with team members
3. **Use Gitpod CLI**: Install Gitpod CLI for local development
4. **Monitor Usage**: Keep track of your Gitpod usage
5. **Backup Important Data**: Don't rely solely on Gitpod for data storage

## 🔗 Useful Resources

### Documentation
- [Gitpod Documentation](https://www.gitpod.io/docs)
- [Office.js API Reference](https://docs.microsoft.com/en-us/office/dev/add-ins/reference/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [Webpack Documentation](https://webpack.js.org/concepts/)

### Tools and Extensions
- [Office Add-in Samples](https://github.com/OfficeDev/Office-Add-in-samples)
- [Office Add-in Development Tools](https://docs.microsoft.com/en-us/office/dev/add-ins/develop/develop-add-ins-vscode)
- [Gitpod CLI](https://www.gitpod.io/docs/command-line-interface)

### Community
- [Gitpod Community](https://community.gitpod.io/)
- [Office Add-ins Community](https://techcommunity.microsoft.com/t5/microsoft-365-developer/ct-p/Microsoft365Developer)
- [TypeScript Community](https://www.typescriptlang.org/community)

## 📞 Support

For issues and questions:

1. **Repository Issues**: Create an issue in this repository
2. **Gitpod Issues**: Check [Gitpod Support](https://www.gitpod.io/support)
3. **Office.js Issues**: Check [Office Add-ins Documentation](https://docs.microsoft.com/en-us/office/dev/add-ins/)
4. **Community Help**: Join the relevant communities above

---

**Happy coding with TypeScript and Excel in Gitpod! 🎉**

*This guide is part of the TypeScript Excel Development Environment project. For more information, see the main README.md file.*
