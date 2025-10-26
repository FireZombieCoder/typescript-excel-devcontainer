#!/bin/bash

# Excel Development Helper Script
# Comprehensive tool for configuring and running TypeScript Excel web apps

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Print functions
print_header() {
    echo -e "\n${PURPLE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC}  $1"
    echo -e "${PURPLE}╚════════════════════════════════════════════════════════════╝${NC}\n"
}

print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[✓]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
print_error() { echo -e "${RED}[✗]${NC} $1"; }

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    local missing=0
    local node_missing=0
    
    if ! command -v node &> /dev/null; then
        print_warning "Node.js not found"
        node_missing=1
        missing=1
    else
        print_success "Node.js $(node --version)"
    fi
    
    if ! command -v npm &> /dev/null; then
        print_warning "npm not found"
        missing=1
    else
        print_success "npm $(npm --version)"
    fi
    
    if ! command -v git &> /dev/null; then
        print_error "Git not found"
        missing=1
    else
        print_success "Git $(git --version | cut -d' ' -f3)"
    fi
    
    if [ $node_missing -eq 1 ]; then
        print_warning "Node.js is required for Excel development"
        echo -e "\n${YELLOW}To install Node.js:${NC}"
        echo -e "  ${CYAN}curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -${NC}"
        echo -e "  ${CYAN}sudo apt-get install -y nodejs${NC}"
        echo -e "\nOr run: ${CYAN}./scripts/excel-dev-helper.sh install-node${NC}\n"
        
        if [ "$1" != "skip-exit" ]; then
            exit 1
        fi
    fi
    
    if [ $missing -eq 1 ] && [ "$1" != "skip-exit" ]; then
        print_error "Missing prerequisites. Please install required tools."
        exit 1
    fi
    
    if [ $missing -eq 0 ]; then
        print_success "All prerequisites satisfied"
    fi
}

# Install Node.js
install_nodejs() {
    print_header "Installing Node.js 20"
    
    if command -v node &> /dev/null; then
        print_warning "Node.js is already installed: $(node --version)"
        echo -n "Reinstall? (y/N): "
        read answer
        if [[ ! "$answer" =~ ^[Yy]$ ]]; then
            return 0
        fi
    fi
    
    print_status "Adding NodeSource repository..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - || {
        print_error "Failed to add NodeSource repository"
        return 1
    }
    
    print_status "Installing Node.js..."
    sudo apt-get install -y nodejs || {
        print_error "Failed to install Node.js"
        return 1
    }
    
    print_success "Node.js installed: $(node --version)"
    print_success "npm installed: $(npm --version)"
}

# Install global tools
install_global_tools() {
    print_header "Installing Global TypeScript Tools"
    
    if ! command -v npm &> /dev/null; then
        print_error "npm not found. Please install Node.js first."
        return 1
    fi
    
    print_status "Installing TypeScript and build tools..."
    npm install -g typescript ts-node webpack webpack-cli || {
        print_error "Failed to install global tools"
        return 1
    }
    
    print_status "Installing Office.js development tools..."
    npm install -g office-addin-dev-certs office-addin-debugging \
        office-addin-manifest office-addin-validator || {
        print_warning "Some Office.js tools failed to install (non-critical)"
    }
    
    print_success "Global tools installed"
}

# Create new project
create_new_project() {
    local project_name=$1
    
    if [ -z "$project_name" ]; then
        echo -n "Enter project name: "
        read project_name
    fi
    
    if [ -z "$project_name" ]; then
        print_error "Project name cannot be empty"
        return 1
    fi
    
    print_header "Creating Project: $project_name"
    
    if [ -f "./scripts/setup-project.sh" ]; then
        ./scripts/setup-project.sh "$project_name"
    else
        print_error "setup-project.sh not found"
        return 1
    fi
    
    print_success "Project created at: ./projects/$project_name"
}

# List projects
list_projects() {
    print_header "Available Projects"
    
    if [ ! -d "./projects" ]; then
        print_warning "No projects directory found"
        return 1
    fi
    
    local count=0
    for dir in ./projects/*/; do
        if [ -d "$dir" ]; then
            local name=$(basename "$dir")
            echo -e "${CYAN}[$((++count))]${NC} $name"
            
            if [ -f "$dir/package.json" ]; then
                local desc=$(grep -o '"description": *"[^"]*"' "$dir/package.json" | cut -d'"' -f4)
                [ -n "$desc" ] && echo -e "    ${BLUE}→${NC} $desc"
            fi
        fi
    done
    
    if [ $count -eq 0 ]; then
        print_warning "No projects found"
    fi
}

# Start dev server
start_dev_server() {
    local project_name=$1
    
    if [ -z "$project_name" ]; then
        list_projects
        echo -n "Enter project name: "
        read project_name
    fi
    
    local project_path="./projects/$project_name"
    
    if [ ! -d "$project_path" ]; then
        print_error "Project not found: $project_name"
        return 1
    fi
    
    print_header "Starting Dev Server: $project_name"
    
    cd "$project_path"
    
    if [ ! -d "node_modules" ]; then
        print_status "Installing dependencies..."
        npm install
    fi
    
    print_success "Starting development server on port 3000..."
    npm run dev-server
}

# Build project
build_project() {
    local project_name=$1
    local mode=${2:-production}
    
    if [ -z "$project_name" ]; then
        list_projects
        echo -n "Enter project name: "
        read project_name
    fi
    
    local project_path="./projects/$project_name"
    
    if [ ! -d "$project_path" ]; then
        print_error "Project not found: $project_name"
        return 1
    fi
    
    print_header "Building Project: $project_name ($mode)"
    
    cd "$project_path"
    
    if [ "$mode" = "development" ]; then
        npm run build:dev
    else
        npm run build
    fi
    
    print_success "Build complete: $project_path/dist/"
}

# Run tests
run_tests() {
    local project_name=$1
    
    if [ -z "$project_name" ]; then
        list_projects
        echo -n "Enter project name: "
        read project_name
    fi
    
    local project_path="./projects/$project_name"
    
    if [ ! -d "$project_path" ]; then
        print_error "Project not found: $project_name"
        return 1
    fi
    
    print_header "Running Tests: $project_name"
    
    cd "$project_path"
    npm test
}

# Environment info
show_environment_info() {
    print_header "Development Environment Information"
    
    echo -e "${CYAN}Node.js:${NC} $(node --version)"
    echo -e "${CYAN}npm:${NC} $(npm --version)"
    echo -e "${CYAN}Git:${NC} $(git --version | cut -d' ' -f3)"
    
    if command -v tsc &> /dev/null; then
        echo -e "${CYAN}TypeScript:${NC} $(tsc --version | cut -d' ' -f2)"
    else
        echo -e "${CYAN}TypeScript:${NC} ${YELLOW}Not installed globally${NC}"
    fi
    
    echo -e "\n${CYAN}Working Directory:${NC} $(pwd)"
    echo -e "${CYAN}Projects Directory:${NC} ./projects/"
    
    if [ -n "$GITPOD_WORKSPACE_ID" ]; then
        echo -e "\n${GREEN}Running in Gitpod${NC}"
        echo -e "${CYAN}Workspace URL:${NC} $GITPOD_WORKSPACE_URL"
    fi
}

# Quick start guide
show_quick_start() {
    print_header "Quick Start Guide"
    
    cat << 'EOF'
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

EOF
}

# Interactive menu
show_menu() {
    while true; do
        print_header "TypeScript Excel Development Helper"
        
        echo -e "${CYAN}1.${NC} Create New Project"
        echo -e "${CYAN}2.${NC} List Projects"
        echo -e "${CYAN}3.${NC} Start Dev Server"
        echo -e "${CYAN}4.${NC} Build Project"
        echo -e "${CYAN}5.${NC} Run Tests"
        echo -e "${CYAN}6.${NC} Install Node.js"
        echo -e "${CYAN}7.${NC} Install Global Tools"
        echo -e "${CYAN}8.${NC} Environment Info"
        echo -e "${CYAN}9.${NC} Quick Start Guide"
        echo -e "${CYAN}0.${NC} Exit"
        
        echo -n -e "\n${YELLOW}Select option [0-9]:${NC} "
        read choice
        
        case $choice in
            1) create_new_project ;;
            2) list_projects ;;
            3) start_dev_server ;;
            4) build_project ;;
            5) run_tests ;;
            6) install_nodejs ;;
            7) install_global_tools ;;
            8) show_environment_info ;;
            9) show_quick_start ;;
            0) print_success "Goodbye!"; exit 0 ;;
            *) print_error "Invalid option" ;;
        esac
        
        echo -e "\n${YELLOW}Press Enter to continue...${NC}"
        read
    done
}

# Main function
main() {
    case "${1:-}" in
        install-node)
            check_prerequisites "skip-exit"
            install_nodejs
            ;;
        install|tools)
            check_prerequisites
            install_global_tools
            ;;
        info|env)
            check_prerequisites "skip-exit"
            show_environment_info
            ;;
        help|guide)
            show_quick_start
            ;;
        create|new)
            check_prerequisites
            create_new_project "$2"
            ;;
        list|ls)
            list_projects
            ;;
        start|dev|serve)
            check_prerequisites
            start_dev_server "$2"
            ;;
        build)
            check_prerequisites
            build_project "$2" "${3:-production}"
            ;;
        test)
            check_prerequisites
            run_tests "$2"
            ;;
        *)
            check_prerequisites "skip-exit"
            show_menu
            ;;
    esac
}

main "$@"
