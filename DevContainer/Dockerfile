# Multi-stage build for TypeScript Excel Development Environment
FROM node:20-bullseye-slim as base

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        curl \
        wget \
        ca-certificates \
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
    && rm -rf /var/lib/apt/lists/*

# Install global Node.js tools
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

# Create non-root user
ARG USERNAME=dev
ARG UID=1000
ARG GID=1000
RUN groupadd --gid ${GID} ${USERNAME} \
    && useradd --uid ${UID} --gid ${GID} --create-home --shell /bin/bash ${USERNAME}

# Switch to user
USER ${USERNAME}
WORKDIR /workspaces

# Create project structure
RUN mkdir -p /workspaces/{projects,templates,examples,docs}

# Install Office.js types and tools
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
RUN cat > /workspaces/tsconfig.json << 'EOF'
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

# Create package.json template
RUN cat > /workspaces/package.template.json << 'EOF'
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

# Create webpack configuration
RUN cat > /workspaces/webpack.config.js << 'EOF'
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
  },
};
EOF

# Create ESLint configuration
RUN cat > /workspaces/.eslintrc.js << 'EOF'
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
RUN cat > /workspaces/.prettierrc << 'EOF'
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
RUN cat > /workspaces/jest.config.js << 'EOF'
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

# Create sample Excel Add-in template
RUN mkdir -p /workspaces/templates/excel-addin-basic/src
RUN cat > /workspaces/templates/excel-addin-basic/src/index.html << 'EOF'
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

RUN cat > /workspaces/templates/excel-addin-basic/src/index.ts << 'EOF'
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

# Create Excel Function Builder template
RUN mkdir -p /workspaces/templates/excel-function-builder/src
RUN cat > /workspaces/templates/excel-function-builder/src/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Excel Function Builder</title>
    <script src="https://appsforoffice.microsoft.com/lib/1/hosted/office.js"></script>
</head>
<body>
    <div id="content">
        <h1>Excel Function Builder</h1>
        <div>
            <label for="functionName">Function Name:</label>
            <input type="text" id="functionName" placeholder="MYFUNCTION" />
        </div>
        <div>
            <label for="formula">Formula:</label>
            <textarea id="formula" placeholder="=SUM(A1:A10)"></textarea>
        </div>
        <button id="insertFunction">Insert Function</button>
        <div id="result"></div>
    </div>
    <script src="bundle.js"></script>
</body>
</html>
EOF

RUN cat > /workspaces/templates/excel-function-builder/src/index.ts << 'EOF'
// Initialize Office.js
Office.onReady((info) => {
    if (info.host === Office.HostType.Excel) {
        document.getElementById('insertFunction')?.addEventListener('click', insertFunction);
    }
});

async function insertFunction() {
    const functionName = (document.getElementById('functionName') as HTMLInputElement)?.value;
    const formula = (document.getElementById('formula') as HTMLTextAreaElement)?.value;
    
    if (!functionName || !formula) {
        alert('Please enter both function name and formula');
        return;
    }
    
    try {
        await Excel.run(async (context) => {
            const range = context.workbook.getSelectedRange();
            range.formulas = [[`=${formula}`]];
            await context.sync();
        });
        
        document.getElementById('result')!.innerHTML = `Function ${functionName} inserted successfully!`;
    } catch (error) {
        console.error('Error:', error);
        document.getElementById('result')!.innerHTML = `Error: ${error.message}`;
    }
}
EOF

# Create Excel Game template
RUN mkdir -p /workspaces/templates/excel-game/src
RUN cat > /workspaces/templates/excel-game/src/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Excel Game</title>
    <script src="https://appsforoffice.microsoft.com/lib/1/hosted/office.js"></script>
    <style>
        .game-container {
            text-align: center;
            padding: 20px;
        }
        .game-board {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 5px;
            max-width: 300px;
            margin: 20px auto;
        }
        .cell {
            width: 80px;
            height: 80px;
            border: 2px solid #333;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            cursor: pointer;
            background: #f0f0f0;
        }
        .cell:hover {
            background: #e0e0e0;
        }
        .cell.x { color: #ff0000; }
        .cell.o { color: #0000ff; }
    </style>
</head>
<body>
    <div class="game-container">
        <h1>Tic-Tac-Toe in Excel</h1>
        <div class="game-board" id="gameBoard"></div>
        <button id="newGame">New Game</button>
        <div id="status"></div>
    </div>
    <script src="bundle.js"></script>
</body>
</html>
EOF

RUN cat > /workspaces/templates/excel-game/src/index.ts << 'EOF'
// Tic-Tac-Toe Game in Excel
let currentPlayer = 'X';
let gameBoard = ['', '', '', '', '', '', '', '', ''];
let gameActive = true;

Office.onReady((info) => {
    if (info.host === Office.HostType.Excel) {
        initializeGame();
        document.getElementById('newGame')?.addEventListener('click', resetGame);
    }
});

function initializeGame() {
    const gameBoardElement = document.getElementById('gameBoard');
    if (!gameBoardElement) return;
    
    gameBoardElement.innerHTML = '';
    
    for (let i = 0; i < 9; i++) {
        const cell = document.createElement('div');
        cell.className = 'cell';
        cell.dataset.index = i.toString();
        cell.addEventListener('click', handleCellClick);
        gameBoardElement.appendChild(cell);
    }
    
    updateStatus();
}

function handleCellClick(event: Event) {
    const cell = event.target as HTMLElement;
    const index = parseInt(cell.dataset.index!);
    
    if (gameBoard[index] !== '' || !gameActive) return;
    
    gameBoard[index] = currentPlayer;
    cell.textContent = currentPlayer;
    cell.classList.add(currentPlayer.toLowerCase());
    
    if (checkWinner()) {
        gameActive = false;
        updateStatus(`Player ${currentPlayer} wins!`);
        return;
    }
    
    if (gameBoard.every(cell => cell !== '')) {
        gameActive = false;
        updateStatus('It\'s a tie!');
        return;
    }
    
    currentPlayer = currentPlayer === 'X' ? 'O' : 'X';
    updateStatus();
}

function checkWinner(): boolean {
    const winPatterns = [
        [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
        [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
        [0, 4, 8], [2, 4, 6] // Diagonals
    ];
    
    return winPatterns.some(pattern => 
        pattern.every(index => gameBoard[index] === currentPlayer)
    );
}

function updateStatus(message?: string) {
    const statusElement = document.getElementById('status');
    if (!statusElement) return;
    
    if (message) {
        statusElement.textContent = message;
    } else {
        statusElement.textContent = `Current Player: ${currentPlayer}`;
    }
}

function resetGame() {
    currentPlayer = 'X';
    gameBoard = ['', '', '', '', '', '', '', '', ''];
    gameActive = true;
    initializeGame();
}

// Optional: Sync game state with Excel
async function syncWithExcel() {
    try {
        await Excel.run(async (context) => {
            const range = context.workbook.getSelectedRange();
            range.values = [
                [gameBoard[0], gameBoard[1], gameBoard[2]],
                [gameBoard[3], gameBoard[4], gameBoard[5]],
                [gameBoard[6], gameBoard[7], gameBoard[8]]
            ];
            await context.sync();
        });
    } catch (error) {
        console.error('Error syncing with Excel:', error);
    }
}
EOF

# Create README template
RUN cat > /workspaces/README.md << 'EOF'
# TypeScript Excel Development Environment

A comprehensive devcontainer for building TypeScript applications with Microsoft Excel integration.

## Features

- **TypeScript Development**: Full TypeScript toolchain with latest features
- **Office.js Integration**: Complete Office.js SDK and types
- **Excel-Specific Tools**: Specialized tools for Excel Add-in development
- **Modern Build Tools**: Webpack, Rollup, and other modern bundlers
- **Testing Framework**: Jest and Playwright for comprehensive testing
- **Code Quality**: ESLint, Prettier, and other code quality tools
- **Sample Projects**: Ready-to-use templates for common Excel applications

## Quick Start

1. Open this devcontainer in VS Code
2. Navigate to the `templates` directory
3. Choose a template and copy it to your project
4. Run `npm install` to install dependencies
5. Run `npm run dev-server` to start development

## Available Templates

### Excel Add-in Basic
A simple Excel Add-in that demonstrates basic Office.js functionality.

### Excel Function Builder
A tool for creating and inserting custom Excel functions.

### Excel Game
A Tic-Tac-Toe game that runs inside Excel.

## Development Commands

- `npm run build` - Build for production
- `npm run build:dev` - Build for development
- `npm run start` - Start development server
- `npm test` - Run tests
- `npm run lint` - Run ESLint
- `npm run format` - Format code with Prettier

## Office.js Resources

- [Office.js API Documentation](https://docs.microsoft.com/en-us/office/dev/add-ins/reference/overview/office-add-ins-reference-overview)
- [Excel Add-in Development](https://docs.microsoft.com/en-us/office/dev/add-ins/excel/)
- [Office Add-in Samples](https://github.com/OfficeDev/Office-Add-in-samples)

## Troubleshooting

### Common Issues

1. **Office.js not loading**: Ensure you're running in an Office environment
2. **TypeScript errors**: Check your tsconfig.json configuration
3. **Build failures**: Verify all dependencies are installed

### Getting Help

- Check the [Office.js documentation](https://docs.microsoft.com/en-us/office/dev/add-ins/)
- Review the sample projects in the `templates` directory
- Check the [Office Add-in samples repository](https://github.com/OfficeDev/Office-Add-in-samples)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

MIT License - see LICENSE file for details
EOF

# Set proper permissions
RUN chown -R ${USERNAME}:${USERNAME} /workspaces

# Expose default port
EXPOSE 3000

# Default command
CMD ["bash"]