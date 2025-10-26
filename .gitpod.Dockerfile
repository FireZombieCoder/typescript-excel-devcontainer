# Gitpod Dockerfile for TypeScript Excel Development
# Optimized for Office Add-in development on Windows 11 with WSL2

FROM gitpod/workspace-full:latest

# Install additional system dependencies
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        python3 \
        python3-pip \
        python3-venv \
        unzip \
        zip \
        jq \
        vim \
        nano \
        htop \
        tree \
        ca-certificates \
        gnupg \
        lsb-release \
        software-properties-common \
        apt-transport-https \
        wget \
        curl \
        git \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20 (if not already installed)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Verify Node.js installation
RUN node --version && npm --version

# Install global Node.js tools for Office development
RUN npm install -g \
    typescript \
    ts-node \
    @types/node \
    eslint \
    prettier \
    webpack \
    webpack-cli \
    rollup \
    jest \
    @playwright/test \
    office-addin-dev-certs \
    office-addin-debugging \
    office-addin-lint \
    office-addin-manifest \
    office-addin-prettier-config \
    office-addin-dev-settings \
    office-addin-sso \
    office-addin-taskpane \
    office-addin-validator \
    yo \
    generator-office

# Install Office.js types and tools globally
RUN npm install -g \
    @types/office-js \
    @types/office-runtime \
    office-js \
    office-js-helpers

# Create workspace structure
RUN mkdir -p /workspace/{projects,templates,examples,docs,scripts}

# Set up Git configuration
RUN git config --global init.defaultBranch main && \
    git config --global pull.rebase false && \
    git config --global user.name "Gitpod User" && \
    git config --global user.email "gitpod@example.com"

# Switch back to gitpod user
USER gitpod

# Set working directory
WORKDIR /workspace

# Install Office.js types and tools for the workspace
RUN npm init -y && \
    npm install --save-dev \
    @types/office-js \
    @types/office-runtime \
    office-js \
    office-js-helpers \
    office-ui-fabric-react \
    @fluentui/react \
    @fluentui/react-components

# Create TypeScript configuration
RUN cat > /workspace/tsconfig.json << 'EOF'
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

# Create webpack configuration
RUN cat > /workspace/webpack.config.js << 'EOF'
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

# Create ESLint configuration
RUN cat > /workspace/.eslintrc.js << 'EOF'
module.exports = {
  env: {
    browser: true,
    es2021: true,
    node: true,
  },
  extends: [
    'eslint:recommended',
    '@typescript-eslint/recommended',
  ],
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
  },
  plugins: ['@typescript-eslint'],
  rules: {
    'no-console': 'warn',
    'no-unused-vars': 'error',
    '@typescript-eslint/no-explicit-any': 'warn',
  },
};
EOF

# Create Prettier configuration
RUN cat > /workspace/.prettierrc << 'EOF'
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false
}
EOF

# Create Jest configuration
RUN cat > /workspace/jest.config.js << 'EOF'
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'jsdom',
  roots: ['<rootDir>/src'],
  testMatch: ['**/__tests__/**/*.ts', '**/?(*.)+(spec|test).ts'],
  transform: {
    '^.+\\.ts$': 'ts-jest',
  },
  collectCoverageFrom: [
    'src/**/*.ts',
    '!src/**/*.d.ts',
    '!src/**/*.test.ts',
    '!src/**/*.spec.ts',
  ],
  coverageDirectory: 'coverage',
  coverageReporters: ['text', 'lcov', 'html'],
};
EOF

# Create a sample Excel Add-in template
RUN mkdir -p /workspace/templates/excel-addin-basic/src
RUN cat > /workspace/templates/excel-addin-basic/src/index.html << 'EOF'
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

RUN cat > /workspace/templates/excel-addin-basic/src/index.ts << 'EOF'
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

# Create a basic package.json template
RUN cat > /workspace/package.template.json << 'EOF'
{
  "name": "excel-addin-project",
  "version": "1.0.0",
  "description": "Excel Add-in built with TypeScript",
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
  "dependencies": {
    "office-js": "^1.1.0",
    "office-js-helpers": "^1.0.0"
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

# Set proper permissions
RUN chown -R gitpod:gitpod /workspace

# Expose ports
EXPOSE 3000 8080 9229

# Default command
CMD ["bash"]
