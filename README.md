# TypeScript Excel Development Environment

A comprehensive, reusable devcontainer specifically designed for TypeScript development focused on Microsoft Excel applications. This environment provides everything you need to build Excel Add-ins, function builders, games, and other Office applications.

## 🚀 Features

- **Complete TypeScript Development Stack**: Node.js 20, TypeScript 5.0+, and modern JavaScript tooling
- **Office.js Integration**: Full Office.js SDK with TypeScript definitions
- **Excel-Specific Tools**: Specialized tools for Excel Add-in development
- **Modern Build Tools**: Webpack, Rollup, and other modern bundlers
- **Comprehensive Testing**: Jest and Playwright for unit and integration testing
- **Code Quality Tools**: ESLint, Prettier, and automated formatting
- **Ready-to-Use Templates**: Pre-built templates for common Excel applications
- **VS Code Integration**: Optimized extensions and settings for Office development

## 📁 Project Structure

```
DevContainer/
├── Dockerfile              # Multi-stage Docker build
├── devcontainer.json       # VS Code devcontainer configuration
└── README.md              # This file

.gitignore                 # Git ignore rules
.gitattributes            # Line ending normalization
.dockerignore             # Docker build optimization

examples/                   # Example projects and demos
├── excel-addin-basic/     # Basic Excel Add-in example
├── excel-function-builder/ # Excel function builder example
└── excel-game/            # Excel game example

templates/                  # Project templates
├── excel-addin-basic/     # Basic Excel Add-in template
├── excel-function-builder/ # Excel function builder template
└── excel-game/            # Excel game template

docs/                      # Documentation
├── getting-started.md     # Getting started guide
├── api-reference.md       # API reference
└── troubleshooting.md     # Troubleshooting guide

scripts/                   # Utility scripts
├── setup-project.sh      # Project setup script
├── build-all.sh          # Build all projects script
└── test-all.sh           # Test all projects script
```

## 🛠️ Quick Start

### Prerequisites

- [Docker](https://www.docker.com/get-started)
- [Cursor IDE](https://cursor.sh/) or [VS Code](https://code.visualstudio.com/)
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### Getting Started

#### Option 1: Using the Helper Script (Recommended)

1. **Clone or download this repository**
   ```bash
   git clone <repository-url>
   cd Devcontainers
   ```

2. **Open the devcontainer using the helper script**
   ```bash
   ./scripts/open-devcontainer.sh
   ```

3. **Or build and open in one command**
   ```bash
   ./scripts/open-devcontainer.sh --build
   ```

#### Option 2: Manual Setup

1. **Clone or download this repository**
   ```bash
   git clone <repository-url>
   cd Devcontainers
   ```

2. **Open in Cursor IDE with Dev Containers**
   - Open Cursor IDE
   - Open the `DevContainer` folder
   - Cursor should prompt you to "Reopen in Container"
   - Click "Reopen in Container"

3. **Wait for the container to build**
   - The first build may take several minutes
   - All dependencies will be automatically installed

4. **Start developing**
   - Navigate to the `templates` directory
   - Choose a template and copy it to your project
   - Run `npm install` to install dependencies
   - Run `npm run dev-server` to start development

### Command-Line Usage

For advanced users, you can open the devcontainer directly via command-line:

```bash
# Using the helper script
./scripts/open-devcontainer.sh

# Or manually with Cursor CLI
CONF='{"settingType":"config", "workspacePath": ".", "devcontainerPath": "./DevContainer/devcontainer.json"}'
HEX_CONF=$(printf "$CONF" | od -A n -t x1 | tr -d '[\n\t ]')
cursor --folder-uri "vscode-remote://dev-container+${HEX_CONF}/workspaces"
```

For detailed command-line usage, see the [DevContainer Usage Guide](docs/devcontainer-usage-guide.md).

## 📚 Available Templates

### Excel Add-in Basic
A simple Excel Add-in that demonstrates basic Office.js functionality.

**Features:**
- Basic Office.js integration
- Cell manipulation
- Error handling
- TypeScript support

**Usage:**
```bash
cp -r templates/excel-addin-basic my-excel-addin
cd my-excel-addin
npm install
npm run dev-server
```

### Excel Function Builder
A tool for creating and inserting custom Excel functions.

**Features:**
- Custom function creation
- Formula validation
- Excel integration
- User-friendly interface

**Usage:**
```bash
cp -r templates/excel-function-builder my-function-builder
cd my-function-builder
npm install
npm run dev-server
```

### Excel Game
A Tic-Tac-Toe game that runs inside Excel.

**Features:**
- Interactive game interface
- Excel integration
- Game state management
- Responsive design

**Usage:**
```bash
cp -r templates/excel-game my-excel-game
cd my-excel-game
npm install
npm run dev-server
```

## 🔧 Development Commands

### Build Commands
```bash
npm run build          # Build for production
npm run build:dev      # Build for development
npm run start          # Start development server
npm run dev-server     # Start development server with hot reload
```

### Testing Commands
```bash
npm test               # Run all tests
npm run test:watch     # Run tests in watch mode
npm run test:coverage  # Run tests with coverage report
npm run test:ui        # Run Playwright UI tests
```

### Code Quality Commands
```bash
npm run lint           # Run ESLint
npm run lint:fix       # Fix ESLint issues
npm run format         # Format code with Prettier
npm run validate       # Validate Office Add-in manifest
```

### Office Add-in Commands
```bash
npm run sideload       # Sideload Add-in to Excel
npm run validate       # Validate Add-in manifest
npm run dev-server     # Start development server
```

## 📚 Documentation

### Internal Guides
- [Getting Started Guide](docs/getting-started.md) - Step-by-step setup and development
- [DevContainer Usage Guide](docs/devcontainer-usage-guide.md) - Complete guide for using Dev Containers
- [Troubleshooting Guide](docs/troubleshooting.md) - Common issues and solutions

### Configuration Files
- `.gitignore` - Comprehensive ignore rules for Node.js, TypeScript, and devcontainer projects
- `.gitattributes` - Line ending normalization for cross-platform development
- `.dockerignore` - Docker build optimization by excluding unnecessary files

### Office.js Resources
- [Office.js API Documentation](https://docs.microsoft.com/en-us/office/dev/add-ins/reference/overview/office-add-ins-reference-overview)
- [Excel Add-in Development](https://docs.microsoft.com/en-us/office/dev/add-ins/excel/)
- [Office Add-in Samples](https://github.com/OfficeDev/Office-Add-in-samples)
- [Office Add-in Development Tools](https://docs.microsoft.com/en-us/office/dev/add-ins/develop/develop-add-ins-vscode)

## 🐛 Troubleshooting

### Common Issues

1. **Office.js not loading**
   - Ensure you're running in an Office environment
   - Check that the manifest.xml is properly configured
   - Verify the Office.js CDN is accessible

2. **TypeScript errors**
   - Check your tsconfig.json configuration
   - Ensure all dependencies are installed
   - Verify Office.js types are properly imported

3. **Build failures**
   - Verify all dependencies are installed with `npm install`
   - Check for syntax errors in your code
   - Ensure all required files are present

4. **Container build issues**
   - Ensure Docker is running
   - Check available disk space
   - Try rebuilding the container

### Getting Help

- Check the [Office.js documentation](https://docs.microsoft.com/en-us/office/dev/add-ins/)
- Review the sample projects in the `templates` directory
- Check the [Office Add-in samples repository](https://github.com/OfficeDev/Office-Add-in-samples)
- Review the troubleshooting guide in `docs/troubleshooting.md`

## 🔄 Updating the Environment

To update the development environment:

1. **Update the Dockerfile**
   - Modify the Dockerfile to include new dependencies
   - Rebuild the container

2. **Update VS Code extensions**
   - Modify the `extensions` array in `devcontainer.json`
   - Rebuild the container

3. **Update project templates**
   - Modify templates in the `templates` directory
   - Update documentation as needed

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Update documentation
6. Submit a pull request

## 📄 License

MIT License - see LICENSE file for details

## 🙏 Acknowledgments

- Microsoft Office Add-ins team for Office.js
- VS Code team for Dev Containers
- TypeScript team for excellent tooling
- The open-source community for various tools and libraries

## 📞 Support

For support and questions:

- Create an issue in this repository
- Check the troubleshooting guide
- Review the Office.js documentation
- Join the Office Add-ins community

---

**Happy coding with TypeScript and Excel! 🎉**
