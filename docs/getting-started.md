# Getting Started with TypeScript Excel Development

This guide will help you get up and running with the TypeScript Excel development environment.

## Prerequisites

Before you begin, ensure you have the following installed:

- [Docker](https://www.docker.com/get-started) (version 20.10 or later)
- [VS Code](https://code.visualstudio.com/) (version 1.70 or later)
- [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## Step 1: Set Up the Development Environment

### Option A: Using VS Code Dev Containers (Recommended)

1. **Open the project in VS Code**
   ```bash
   code DevContainer
   ```

2. **Reopen in Container**
   - VS Code should automatically detect the devcontainer configuration
   - Click "Reopen in Container" when prompted
   - Wait for the container to build (this may take 5-10 minutes)

### Option B: Manual Docker Setup

1. **Build the container**
   ```bash
   cd DevContainer
   docker build -t typescript-excel-dev .
   ```

2. **Run the container**
   ```bash
   docker run -it --rm -v $(pwd):/workspaces typescript-excel-dev
   ```

## Step 2: Verify the Installation

Once the container is running, verify that everything is installed correctly:

```bash
# Check Node.js version
node --version

# Check TypeScript version
tsc --version

# Check npm version
npm --version

# Check if Office.js types are available
npm list @types/office-js
```

## Step 3: Create Your First Project

### Using a Template

1. **Navigate to the templates directory**
   ```bash
   cd /workspaces/templates
   ```

2. **Choose a template**
   ```bash
   # For a basic Excel Add-in
   cp -r excel-addin-basic ../my-first-addin
   
   # For a function builder
   cp -r excel-function-builder ../my-function-builder
   
   # For a game
   cp -r excel-game ../my-excel-game
   ```

3. **Set up the project**
   ```bash
   cd ../my-first-addin
   npm install
   ```

4. **Start development**
   ```bash
   npm run dev-server
   ```

### Creating a New Project from Scratch

1. **Create a new directory**
   ```bash
   mkdir /workspaces/my-new-project
   cd /workspaces/my-new-project
   ```

2. **Initialize the project**
   ```bash
   npm init -y
   ```

3. **Install dependencies**
   ```bash
   npm install --save-dev typescript @types/office-js office-js webpack webpack-cli ts-loader html-webpack-plugin
   ```

4. **Copy configuration files**
   ```bash
   cp /workspaces/tsconfig.json .
   cp /workspaces/webpack.config.js .
   cp /workspaces/.eslintrc.js .
   cp /workspaces/.prettierrc .
   cp /workspaces/jest.config.js .
   ```

5. **Create your source files**
   ```bash
   mkdir src
   # Create your TypeScript files in the src directory
   ```

## Step 4: Understanding the Project Structure

### Key Files

- **`tsconfig.json`**: TypeScript configuration
- **`webpack.config.js`**: Webpack build configuration
- **`package.json`**: Project dependencies and scripts
- **`src/index.ts`**: Main TypeScript entry point
- **`src/index.html`**: HTML template for the Add-in

### Important Directories

- **`src/`**: Source code directory
- **`dist/`**: Built/compiled files (created after build)
- **`node_modules/`**: Dependencies (created after npm install)

## Step 5: Development Workflow

### Daily Development

1. **Start the development server**
   ```bash
   npm run dev-server
   ```

2. **Make changes to your code**
   - Edit TypeScript files in the `src/` directory
   - The development server will automatically reload

3. **Test your changes**
   ```bash
   npm test
   ```

4. **Format your code**
   ```bash
   npm run format
   ```

5. **Lint your code**
   ```bash
   npm run lint
   ```

### Building for Production

1. **Build the project**
   ```bash
   npm run build
   ```

2. **Verify the build**
   - Check the `dist/` directory for compiled files
   - Ensure all assets are properly bundled

### Testing

1. **Run unit tests**
   ```bash
   npm test
   ```

2. **Run tests in watch mode**
   ```bash
   npm run test:watch
   ```

3. **Generate coverage report**
   ```bash
   npm run test:coverage
   ```

## Step 6: Office.js Development

### Basic Office.js Setup

```typescript
// Initialize Office.js
Office.onReady((info) => {
    if (info.host === Office.HostType.Excel) {
        // Your Excel-specific code here
        console.log('Excel is ready!');
    }
});
```

### Common Excel Operations

```typescript
// Get the selected range
await Excel.run(async (context) => {
    const range = context.workbook.getSelectedRange();
    range.load('values');
    await context.sync();
    console.log('Selected range values:', range.values);
});

// Set cell values
await Excel.run(async (context) => {
    const range = context.workbook.getSelectedRange();
    range.values = [['Hello, Excel!']];
    await context.sync();
});
```

### Error Handling

```typescript
try {
    await Excel.run(async (context) => {
        // Your Excel operations here
    });
} catch (error) {
    console.error('Error:', error);
    // Handle the error appropriately
}
```

## Step 7: Debugging

### VS Code Debugging

1. **Set breakpoints** in your TypeScript code
2. **Press F5** to start debugging
3. **Use the debug console** to inspect variables

### Console Logging

```typescript
console.log('Debug message');
console.error('Error message');
console.warn('Warning message');
```

### Office.js Debugging

```typescript
// Enable Office.js debugging
Office.debug = true;

// Log Office.js events
Office.onReady((info) => {
    console.log('Office.js ready:', info);
});
```

## Step 8: Next Steps

### Learn More

- [Office.js API Documentation](https://docs.microsoft.com/en-us/office/dev/add-ins/reference/overview/office-add-ins-reference-overview)
- [Excel Add-in Development](https://docs.microsoft.com/en-us/office/dev/add-ins/excel/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)

### Explore Examples

- Check out the examples in the `examples/` directory
- Review the templates in the `templates/` directory
- Look at the [Office Add-in samples](https://github.com/OfficeDev/Office-Add-in-samples)

### Join the Community

- [Office Add-ins Community](https://techcommunity.microsoft.com/t5/microsoft-365-developer/ct-p/Microsoft365Developer)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/office-js)
- [GitHub Discussions](https://github.com/OfficeDev/Office-Add-in-samples/discussions)

## Troubleshooting

If you encounter issues:

1. **Check the troubleshooting guide** in `docs/troubleshooting.md`
2. **Review the logs** for error messages
3. **Verify your setup** using the verification steps above
4. **Ask for help** in the community forums

---

**Happy coding! 🎉**
