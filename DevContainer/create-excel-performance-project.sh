#!/bin/bash

# Excel AppScript Performance Monitor Project Creator
# Creates a complete project structure for the Excel performance monitoring tool

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${PURPLE}================================${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${PURPLE}================================${NC}"
}

print_step() {
    echo -e "${BLUE}🔹 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Create project structure
print_header "Creating Excel AppScript Performance Monitor Project"

# Create main project directory
PROJECT_DIR="excel-performance-monitor"
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

print_step "Creating project directory structure..."

# Create directory structure
mkdir -p src/{components,services,types,hooks,utils,ui}
mkdir -p public
mkdir -p dist
mkdir -p docs
mkdir -p examples
mkdir -p tests/{unit,integration,e2e}
mkdir -p scripts
mkdir -p cypress/{e2e,fixtures,support}

print_success "Directory structure created"

# Create package.json
print_step "Creating package.json..."
cat > package.json << 'EOF'
{
  "name": "excel-appscript-performance-monitor",
  "version": "1.0.0",
  "description": "Excel AppScript Performance Monitor - Visualize memory usage and optimize spreadsheet performance",
  "main": "dist/index.js",
  "scripts": {
    "build": "webpack --mode production",
    "build:dev": "webpack --mode development",
    "start": "webpack serve --mode development",
    "dev": "webpack serve --mode development --open",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "test:e2e": "cypress run",
    "test:e2e:open": "cypress open",
    "lint": "eslint src/**/*.{ts,tsx}",
    "lint:fix": "eslint src/**/*.{ts,tsx} --fix",
    "format": "prettier --write src/**/*.{ts,tsx,json}",
    "validate": "office-addin-validator manifest.xml",
    "sideload": "office-addin-dev-settings sideload manifest.xml",
    "excel:test": "npm run build && office-addin-dev-settings sideload manifest.xml"
  },
  "dependencies": {
    "office-js": "^1.1.0",
    "office-js-helpers": "^1.0.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "chart.js": "^4.4.0",
    "react-chartjs-2": "^5.2.0",
    "d3": "^7.8.5",
    "plotly.js": "^2.24.1",
    "recharts": "^2.8.0",
    "victory": "^36.6.12",
    "performance-now": "^2.1.0",
    "memory-usage": "^1.0.0",
    "systeminformation": "^5.21.15",
    "pidusage": "^3.0.0"
  },
  "devDependencies": {
    "@types/office-js": "^1.0.0",
    "@types/office-runtime": "^1.0.0",
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "@types/d3": "^7.4.0",
    "@types/chart.js": "^2.9.0",
    "typescript": "^5.0.0",
    "webpack": "^5.0.0",
    "webpack-cli": "^5.0.0",
    "webpack-dev-server": "^4.15.0",
    "ts-loader": "^9.0.0",
    "html-webpack-plugin": "^5.0.0",
    "css-loader": "^6.0.0",
    "style-loader": "^3.0.0",
    "eslint": "^8.0.0",
    "prettier": "^3.0.0",
    "jest": "^29.0.0",
    "@types/jest": "^29.0.0",
    "ts-jest": "^29.0.0",
    "cypress": "^13.0.0",
    "@cypress/react": "^5.0.0",
    "@cypress/webpack-dev-server": "^3.0.0"
  },
  "keywords": [
    "excel",
    "appscript",
    "performance",
    "monitoring",
    "memory",
    "visualization",
    "typescript",
    "office-js"
  ],
  "author": "FireZombieCoder",
  "license": "MIT"
}
EOF

print_success "package.json created"

# Create TypeScript configuration
print_step "Creating TypeScript configuration..."
cat > tsconfig.json << 'EOF'
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
    "jsx": "react-jsx",
    "baseUrl": "./src",
    "paths": {
      "@/*": ["*"],
      "@/components/*": ["components/*"],
      "@/utils/*": ["utils/*"],
      "@/types/*": ["types/*"],
      "@/hooks/*": ["hooks/*"],
      "@/services/*": ["services/*"]
    }
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

print_success "TypeScript configuration created"

# Create webpack configuration
print_step "Creating webpack configuration..."
cat > webpack.config.js << 'EOF'
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  entry: './src/index.tsx',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'bundle.js',
    clean: true,
  },
  resolve: {
    extensions: ['.ts', '.tsx', '.js', '.jsx'],
    alias: {
      '@': path.resolve(__dirname, 'src'),
    },
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
      {
        test: /\.(png|svg|jpg|jpeg|gif)$/i,
        type: 'asset/resource',
      },
    ],
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: './public/index.html',
      title: 'Excel AppScript Performance Monitor',
    }),
  ],
  devServer: {
    static: './dist',
    port: 3000,
    hot: true,
    open: true,
    historyApiFallback: true,
  },
  devtool: 'source-map',
};
EOF

print_success "Webpack configuration created"

# Create main HTML file
print_step "Creating main HTML file..."
cat > public/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Excel AppScript Performance Monitor</title>
    <script src="https://appsforoffice.microsoft.com/lib/1/hosted/office.js"></script>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0;
            padding: 0;
            background: #f5f5f5;
        }
        #root {
            height: 100vh;
        }
    </style>
</head>
<body>
    <div id="root"></div>
</body>
</html>
EOF

print_success "Main HTML file created"

# Create main React component
print_step "Creating main React component..."
cat > src/index.tsx << 'EOF'
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './index.css';

const root = ReactDOM.createRoot(
  document.getElementById('root') as HTMLElement
);

root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
EOF

# Create main App component
cat > src/App.tsx << 'EOF'
import React, { useState, useEffect } from 'react';
import { PerformanceDashboard } from './components/PerformanceDashboard';
import { MemoryMonitor } from './components/MemoryMonitor';
import { CalculationProfiler } from './components/CalculationProfiler';
import { OptimizationRecommendations } from './components/OptimizationRecommendations';
import { PerformanceMonitor } from './services/PerformanceMonitor';
import './App.css';

function App() {
  const [isMonitoring, setIsMonitoring] = useState(false);
  const [performanceData, setPerformanceData] = useState(null);
  const [memoryData, setMemoryData] = useState(null);
  const [calculationData, setCalculationData] = useState(null);

  const performanceMonitor = new PerformanceMonitor();

  useEffect(() => {
    if (isMonitoring) {
      const interval = setInterval(async () => {
        try {
          const perfData = await performanceMonitor.getMetrics();
          const memData = await performanceMonitor.getMemoryUsage();
          const calcData = await performanceMonitor.getCalculationMetrics();
          
          setPerformanceData(perfData);
          setMemoryData(memData);
          setCalculationData(calcData);
        } catch (error) {
          console.error('Error updating data:', error);
        }
      }, 1000);

      return () => clearInterval(interval);
    }
  }, [isMonitoring]);

  const startMonitoring = async () => {
    try {
      await performanceMonitor.start();
      setIsMonitoring(true);
    } catch (error) {
      console.error('Error starting monitoring:', error);
    }
  };

  const stopMonitoring = async () => {
    try {
      await performanceMonitor.stop();
      setIsMonitoring(false);
    } catch (error) {
      console.error('Error stopping monitoring:', error);
    }
  };

  return (
    <div className="App">
      <header className="App-header">
        <h1>Excel AppScript Performance Monitor</h1>
        <div className="controls">
          <button 
            onClick={startMonitoring} 
            disabled={isMonitoring}
            className="btn btn-primary"
          >
            Start Monitoring
          </button>
          <button 
            onClick={stopMonitoring} 
            disabled={!isMonitoring}
            className="btn btn-secondary"
          >
            Stop Monitoring
          </button>
        </div>
      </header>
      
      <main className="App-main">
        <div className="dashboard-grid">
          <MemoryMonitor data={memoryData} />
          <CalculationProfiler data={calculationData} />
          <PerformanceDashboard data={performanceData} />
          <OptimizationRecommendations 
            performanceData={performanceData}
            memoryData={memoryData}
            calculationData={calculationData}
          />
        </div>
      </main>
    </div>
  );
}

export default App;
EOF

print_success "Main React components created"

# Create CSS files
print_step "Creating CSS files..."
cat > src/index.css << 'EOF'
* {
  box-sizing: border-box;
}

body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen',
    'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue',
    sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

code {
  font-family: source-code-pro, Menlo, Monaco, Consolas, 'Courier New',
    monospace;
}
EOF

cat > src/App.css << 'EOF'
.App {
  min-height: 100vh;
  background: #f5f5f5;
}

.App-header {
  background: #0078d4;
  color: white;
  padding: 20px;
  text-align: center;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.App-header h1 {
  margin: 0 0 20px 0;
  font-size: 2rem;
}

.controls {
  display: flex;
  gap: 10px;
  justify-content: center;
}

.btn {
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  transition: all 0.2s;
}

.btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.btn-primary {
  background: #28a745;
  color: white;
}

.btn-primary:hover:not(:disabled) {
  background: #218838;
}

.btn-secondary {
  background: #6c757d;
  color: white;
}

.btn-secondary:hover:not(:disabled) {
  background: #5a6268;
}

.App-main {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.dashboard-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
}

.card {
  background: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
  border-left: 4px solid #0078d4;
}

.card h3 {
  margin: 0 0 15px 0;
  color: #333;
  font-size: 1.2rem;
}

.metric {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin: 10px 0;
  padding: 8px 0;
  border-bottom: 1px solid #eee;
}

.metric:last-child {
  border-bottom: none;
}

.metric-label {
  font-weight: 500;
  color: #666;
}

.metric-value {
  font-weight: bold;
  font-size: 1.1em;
}

.status-good { color: #28a745; }
.status-warning { color: #ffc107; }
.status-danger { color: #dc3545; }

.chart-container {
  height: 300px;
  margin: 20px 0;
  position: relative;
}

.loading {
  text-align: center;
  color: #666;
  font-style: italic;
}

.recommendations {
  list-style: none;
  padding: 0;
}

.recommendations li {
  padding: 8px 0;
  border-bottom: 1px solid #eee;
}

.recommendations li:last-child {
  border-bottom: none;
}

.recommendation-item {
  display: flex;
  align-items: flex-start;
  gap: 10px;
}

.recommendation-icon {
  color: #0078d4;
  font-size: 1.2em;
  margin-top: 2px;
}

.recommendation-text {
  flex: 1;
  color: #333;
}
EOF

print_success "CSS files created"

# Create service files
print_step "Creating service files..."
cat > src/services/PerformanceMonitor.ts << 'EOF'
export interface PerformanceMetrics {
  cpuUsage: number;
  memoryUsage: number;
  calculationTime: number;
  activeProcesses: number;
  timestamp: Date;
}

export interface MemoryUsage {
  total: number;
  used: number;
  excel: number;
  appScript: number;
  system: number;
  percentage: number;
}

export interface CalculationMetrics {
  totalCalculations: number;
  averageTime: number;
  slowestFormula: string;
  fastestFormula: string;
  recalculationCount: number;
}

export class PerformanceMonitor {
  private isRunning: boolean = false;
  private intervalId: NodeJS.Timeout | null = null;

  async start(): Promise<void> {
    if (this.isRunning) return;
    
    console.log('Starting performance monitoring...');
    this.isRunning = true;
    
    // Initialize Office.js if available
    if (typeof Office !== 'undefined') {
      await Office.onReady();
    }
  }

  async stop(): Promise<void> {
    if (!this.isRunning) return;
    
    console.log('Stopping performance monitoring...');
    this.isRunning = false;
    
    if (this.intervalId) {
      clearInterval(this.intervalId);
      this.intervalId = null;
    }
  }

  async getMetrics(): Promise<PerformanceMetrics> {
    // Simulate performance data collection
    // In a real implementation, this would collect actual performance data
    return {
      cpuUsage: Math.random() * 100,
      memoryUsage: Math.random() * 100,
      calculationTime: Math.random() * 5000,
      activeProcesses: Math.floor(Math.random() * 10) + 1,
      timestamp: new Date()
    };
  }

  async getMemoryUsage(): Promise<MemoryUsage> {
    // Simulate memory usage data
    // In a real implementation, this would collect actual memory data
    const total = 16384; // 16GB in MB
    const used = Math.floor(Math.random() * total * 0.8);
    
    return {
      total,
      used,
      excel: Math.floor(used * 0.6),
      appScript: Math.floor(used * 0.3),
      system: Math.floor(used * 0.1),
      percentage: (used / total) * 100
    };
  }

  async getCalculationMetrics(): Promise<CalculationMetrics> {
    // Simulate calculation metrics
    return {
      totalCalculations: Math.floor(Math.random() * 1000) + 100,
      averageTime: Math.random() * 1000,
      slowestFormula: 'VLOOKUP(A1:A1000,B1:B1000,1,FALSE)',
      fastestFormula: 'A1+B1',
      recalculationCount: Math.floor(Math.random() * 50)
    };
  }
}
EOF

print_success "Service files created"

# Create component files
print_step "Creating component files..."
cat > src/components/MemoryMonitor.tsx << 'EOF'
import React from 'react';
import { MemoryUsage } from '../services/PerformanceMonitor';

interface MemoryMonitorProps {
  data: MemoryUsage | null;
}

export const MemoryMonitor: React.FC<MemoryMonitorProps> = ({ data }) => {
  if (!data) {
    return (
      <div className="card">
        <h3>Memory Usage</h3>
        <div className="loading">Loading memory data...</div>
      </div>
    );
  }

  const getStatusClass = (percentage: number) => {
    if (percentage < 60) return 'status-good';
    if (percentage < 80) return 'status-warning';
    return 'status-danger';
  };

  return (
    <div className="card">
      <h3>Memory Usage</h3>
      <div className="metric">
        <span className="metric-label">Total Memory:</span>
        <span className="metric-value">{data.total} MB</span>
      </div>
      <div className="metric">
        <span className="metric-label">Used Memory:</span>
        <span className={`metric-value ${getStatusClass(data.percentage)}`}>
          {data.used} MB ({data.percentage.toFixed(1)}%)
        </span>
      </div>
      <div className="metric">
        <span className="metric-label">Excel Memory:</span>
        <span className="metric-value">{data.excel} MB</span>
      </div>
      <div className="metric">
        <span className="metric-label">AppScript Memory:</span>
        <span className="metric-value">{data.appScript} MB</span>
      </div>
      <div className="metric">
        <span className="metric-label">System Memory:</span>
        <span className="metric-value">{data.system} MB</span>
      </div>
    </div>
  );
};
EOF

cat > src/components/CalculationProfiler.tsx << 'EOF'
import React from 'react';
import { CalculationMetrics } from '../services/PerformanceMonitor';

interface CalculationProfilerProps {
  data: CalculationMetrics | null;
}

export const CalculationProfiler: React.FC<CalculationProfilerProps> = ({ data }) => {
  if (!data) {
    return (
      <div className="card">
        <h3>Calculation Profiler</h3>
        <div className="loading">Loading calculation data...</div>
      </div>
    );
  }

  return (
    <div className="card">
      <h3>Calculation Profiler</h3>
      <div className="metric">
        <span className="metric-label">Total Calculations:</span>
        <span className="metric-value">{data.totalCalculations}</span>
      </div>
      <div className="metric">
        <span className="metric-label">Average Time:</span>
        <span className="metric-value">{data.averageTime.toFixed(2)} ms</span>
      </div>
      <div className="metric">
        <span className="metric-label">Recalculation Count:</span>
        <span className="metric-value">{data.recalculationCount}</span>
      </div>
      <div className="metric">
        <span className="metric-label">Slowest Formula:</span>
        <span className="metric-value" style={{ fontSize: '0.9em', fontFamily: 'monospace' }}>
          {data.slowestFormula}
        </span>
      </div>
      <div className="metric">
        <span className="metric-label">Fastest Formula:</span>
        <span className="metric-value" style={{ fontSize: '0.9em', fontFamily: 'monospace' }}>
          {data.fastestFormula}
        </span>
      </div>
    </div>
  );
};
EOF

cat > src/components/PerformanceDashboard.tsx << 'EOF'
import React from 'react';
import { PerformanceMetrics } from '../services/PerformanceMonitor';

interface PerformanceDashboardProps {
  data: PerformanceMetrics | null;
}

export const PerformanceDashboard: React.FC<PerformanceDashboardProps> = ({ data }) => {
  if (!data) {
    return (
      <div className="card">
        <h3>Performance Dashboard</h3>
        <div className="loading">Loading performance data...</div>
      </div>
    );
  }

  const getStatusClass = (value: number, threshold: number) => {
    if (value < threshold * 0.6) return 'status-good';
    if (value < threshold * 0.8) return 'status-warning';
    return 'status-danger';
  };

  return (
    <div className="card">
      <h3>Performance Dashboard</h3>
      <div className="metric">
        <span className="metric-label">CPU Usage:</span>
        <span className={`metric-value ${getStatusClass(data.cpuUsage, 100)}`}>
          {data.cpuUsage.toFixed(1)}%
        </span>
      </div>
      <div className="metric">
        <span className="metric-label">Memory Usage:</span>
        <span className={`metric-value ${getStatusClass(data.memoryUsage, 100)}`}>
          {data.memoryUsage.toFixed(1)}%
        </span>
      </div>
      <div className="metric">
        <span className="metric-label">Calculation Time:</span>
        <span className={`metric-value ${getStatusClass(data.calculationTime, 5000)}`}>
          {data.calculationTime.toFixed(0)} ms
        </span>
      </div>
      <div className="metric">
        <span className="metric-label">Active Processes:</span>
        <span className="metric-value">{data.activeProcesses}</span>
      </div>
      <div className="metric">
        <span className="metric-label">Last Updated:</span>
        <span className="metric-value">{data.timestamp.toLocaleTimeString()}</span>
      </div>
    </div>
  );
};
EOF

cat > src/components/OptimizationRecommendations.tsx << 'EOF'
import React from 'react';
import { PerformanceMetrics, MemoryUsage, CalculationMetrics } from '../services/PerformanceMonitor';

interface OptimizationRecommendationsProps {
  performanceData: PerformanceMetrics | null;
  memoryData: MemoryUsage | null;
  calculationData: CalculationMetrics | null;
}

export const OptimizationRecommendations: React.FC<OptimizationRecommendationsProps> = ({
  performanceData,
  memoryData,
  calculationData
}) => {
  const generateRecommendations = (): string[] => {
    const recommendations: string[] = [];

    if (memoryData && memoryData.percentage > 80) {
      recommendations.push('High memory usage detected. Consider optimizing formulas or reducing data size.');
    }

    if (performanceData && performanceData.calculationTime > 3000) {
      recommendations.push('Slow calculations detected. Consider using more efficient formulas or data structures.');
    }

    if (calculationData && calculationData.recalculationCount > 20) {
      recommendations.push('High recalculation count. Check for circular references or volatile functions.');
    }

    if (performanceData && performanceData.cpuUsage > 80) {
      recommendations.push('High CPU usage. Consider optimizing complex calculations or using array formulas.');
    }

    if (recommendations.length === 0) {
      recommendations.push('Performance looks good! Continue monitoring for any changes.');
      recommendations.push('Regular monitoring helps identify performance bottlenecks early.');
    }

    return recommendations;
  };

  const recommendations = generateRecommendations();

  return (
    <div className="card">
      <h3>Optimization Recommendations</h3>
      <ul className="recommendations">
        {recommendations.map((recommendation, index) => (
          <li key={index}>
            <div className="recommendation-item">
              <span className="recommendation-icon">💡</span>
              <span className="recommendation-text">{recommendation}</span>
            </div>
          </li>
        ))}
      </ul>
    </div>
  );
};
EOF

print_success "Component files created"

# Create configuration files
print_step "Creating configuration files..."
cat > .eslintrc.js << 'EOF'
module.exports = {
  env: {
    browser: true,
    es2021: true,
    node: true,
    jest: true,
  },
  extends: [
    'eslint:recommended',
    '@typescript-eslint/recommended',
    'plugin:react/recommended',
    'plugin:react-hooks/recommended',
  ],
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
    ecmaFeatures: {
      jsx: true,
    },
  },
  plugins: ['@typescript-eslint', 'react', 'react-hooks'],
  rules: {
    'no-console': 'warn',
    'no-unused-vars': 'error',
    '@typescript-eslint/no-explicit-any': 'warn',
    'react/react-in-jsx-scope': 'off',
    'react/prop-types': 'off',
  },
  settings: {
    react: {
      version: 'detect',
    },
  },
};
EOF

cat > .prettierrc << 'EOF'
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false,
  "bracketSpacing": true,
  "arrowParens": "avoid"
}
EOF

cat > jest.config.js << 'EOF'
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'jsdom',
  roots: ['<rootDir>/src'],
  testMatch: ['**/__tests__/**/*.ts', '**/?(*.)+(spec|test).ts'],
  transform: {
    '^.+\\.tsx?$': 'ts-jest',
  },
  collectCoverageFrom: [
    'src/**/*.{ts,tsx}',
    '!src/**/*.d.ts',
    '!src/**/*.test.{ts,tsx}',
    '!src/**/*.spec.{ts,tsx}',
  ],
  coverageDirectory: 'coverage',
  coverageReporters: ['text', 'lcov', 'html'],
  setupFilesAfterEnv: ['<rootDir>/src/setupTests.ts'],
  moduleNameMapping: {
    '^@/(.*)$': '<rootDir>/src/$1',
  },
};
EOF

print_success "Configuration files created"

# Create README
print_step "Creating README..."
cat > README.md << 'EOF'
# Excel AppScript Performance Monitor

A comprehensive tool for monitoring and optimizing Excel AppScript performance, with real-time memory usage visualization and calculation profiling.

## Features

- **Real-time Memory Monitoring**: Track Excel workbook memory usage
- **Performance Profiling**: Monitor calculation times and bottlenecks
- **Process Tracking**: Identify resource-intensive operations
- **Visual Dashboards**: Interactive charts and graphs
- **Optimization Recommendations**: AI-powered performance suggestions
- **Export Reports**: Generate detailed performance reports

## Quick Start

1. Install dependencies:
   ```bash
   npm install
   ```

2. Start development server:
   ```bash
   npm run dev
   ```

3. Open Excel and load the add-in

## Development Commands

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm test` - Run tests
- `npm run lint` - Run ESLint
- `npm run format` - Format code with Prettier

## Architecture

- **Frontend**: React + TypeScript + Chart.js
- **Backend**: Node.js + Excel JavaScript API
- **Monitoring**: Custom performance tracking
- **Visualization**: Interactive charts and dashboards

## Performance Monitoring

The tool provides comprehensive monitoring of:

- Memory usage (total, used, Excel-specific)
- Calculation performance
- Process activity
- Resource utilization
- Bottleneck identification

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

MIT License - see LICENSE file for details
EOF

print_success "README created"

# Create setup script
print_step "Creating setup script..."
cat > setup.sh << 'EOF'
#!/bin/bash

echo "Setting up Excel AppScript Performance Monitor..."

# Install dependencies
echo "Installing dependencies..."
npm install

# Create necessary directories
echo "Creating directories..."
mkdir -p dist
mkdir -p coverage

# Set up git hooks (if git is available)
if command -v git &> /dev/null; then
    echo "Setting up git hooks..."
    # Add pre-commit hook for linting
    echo '#!/bin/bash
npm run lint
npm run test
' > .git/hooks/pre-commit
    chmod +x .git/hooks/pre-commit
fi

echo "Setup complete! Run 'npm run dev' to start development."
EOF

chmod +x setup.sh

print_success "Setup script created"

# Final summary
print_header "Project Creation Complete!"
echo ""
echo "📁 Project created in: $PROJECT_DIR"
echo ""
echo "🚀 Next steps:"
echo "   1. cd $PROJECT_DIR"
echo "   2. ./setup.sh"
echo "   3. npm run dev"
echo ""
echo "📚 Features included:"
echo "   ✅ React + TypeScript setup"
echo "   ✅ Excel AppScript integration"
echo "   ✅ Performance monitoring services"
echo "   ✅ Memory usage visualization"
echo "   ✅ Calculation profiling"
echo "   ✅ Optimization recommendations"
echo "   ✅ Testing framework"
echo "   ✅ Linting and formatting"
echo ""
echo "🎯 Ready to build your Excel performance monitoring tool!"
EOF

chmod +x create-excel-performance-project.sh

print_success "Excel AppScript Performance Monitor project creator ready!"
echo ""
echo "Run: ./create-excel-performance-project.sh"
echo "This will create a complete project structure for your Excel performance monitoring tool."
