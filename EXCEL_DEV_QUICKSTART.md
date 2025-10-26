# Excel Development Quick Start

## 🚀 Get Started in 3 Steps

### Step 1: Install Node.js (if needed)

```bash
./scripts/excel-dev-helper.sh install-node
```

### Step 2: Create Your First Excel Add-in

```bash
./scripts/excel-dev-helper.sh create my-first-excel-app
```

### Step 3: Start Development

```bash
./scripts/excel-dev-helper.sh start my-first-excel-app
```

Your development server will start on port 3000!

---

## 📋 All Available Commands

### Interactive Menu
```bash
./scripts/excel-dev-helper.sh
```
Launches an interactive menu with all options.

### Quick Commands

| Command | Description |
|---------|-------------|
| `./scripts/excel-dev-helper.sh install-node` | Install Node.js 20 |
| `./scripts/excel-dev-helper.sh install` | Install global dev tools |
| `./scripts/excel-dev-helper.sh create <name>` | Create new project |
| `./scripts/excel-dev-helper.sh list` | List all projects |
| `./scripts/excel-dev-helper.sh start <name>` | Start dev server |
| `./scripts/excel-dev-helper.sh build <name>` | Build for production |
| `./scripts/excel-dev-helper.sh test <name>` | Run tests |
| `./scripts/excel-dev-helper.sh info` | Show environment info |
| `./scripts/excel-dev-helper.sh help` | Show help guide |

---

## 💡 Common Workflows

### First Time Setup
```bash
# 1. Install Node.js
./scripts/excel-dev-helper.sh install-node

# 2. Install development tools
./scripts/excel-dev-helper.sh install

# 3. Check environment
./scripts/excel-dev-helper.sh info
```

### Create and Run a Project
```bash
# Create project
./scripts/excel-dev-helper.sh create my-excel-calculator

# Start development server
./scripts/excel-dev-helper.sh start my-excel-calculator
```

### Build and Test
```bash
# Run tests
./scripts/excel-dev-helper.sh test my-excel-calculator

# Build for production
./scripts/excel-dev-helper.sh build my-excel-calculator
```

---

## 📁 What Gets Created

When you create a project, you get:

```
projects/my-excel-app/
├── src/
│   ├── index.ts          # Your TypeScript code
│   ├── index.html        # HTML template
│   ├── components/       # UI components
│   ├── utils/            # Helper functions
│   └── types/            # Type definitions
├── tests/                # Jest tests
├── package.json          # Dependencies
├── tsconfig.json         # TypeScript config
├── webpack.config.js     # Build config
└── README.md             # Project docs
```

---

## 🎯 Inside Your Project

Once inside a project directory (`cd projects/my-excel-app`):

```bash
npm run dev-server    # Start dev server
npm run build         # Production build
npm test              # Run tests
npm run lint          # Check code quality
npm run format        # Format code
```

---

## 🌐 Access Your App

### Local Development
- **URL**: http://localhost:3000
- **Hot Reload**: Enabled automatically

### Gitpod
- **URL**: Automatically provided in preview
- **Format**: https://3000-[workspace-id].gitpod.io

---

## 📚 Learn More

- **Full Guide**: [docs/excel-dev-helper-guide.md](docs/excel-dev-helper-guide.md)
- **Getting Started**: [docs/getting-started.md](docs/getting-started.md)
- **Troubleshooting**: [docs/troubleshooting.md](docs/troubleshooting.md)

---

## ⚡ Pro Tips

1. **Use the interactive menu** when exploring: `./scripts/excel-dev-helper.sh`
2. **Check your environment** before starting: `./scripts/excel-dev-helper.sh info`
3. **List projects** to see what's available: `./scripts/excel-dev-helper.sh list`
4. **Use descriptive names** for projects: `excel-calculator` not `calc`

---

**Ready to build Excel Add-ins with TypeScript! 🎉**
