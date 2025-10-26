#!/bin/bash

# Open DevContainer Script
# This script opens the TypeScript Excel devcontainer in Cursor IDE

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -b, --build    Build the container before opening"
    echo "  -c, --clean    Clean build (remove cache)"
    echo "  -l, --logs     Show container logs"
    echo "  -s, --status   Show container status"
    echo ""
    echo "Examples:"
    echo "  $0                    # Open devcontainer"
    echo "  $0 --build           # Build and open devcontainer"
    echo "  $0 --clean           # Clean build and open devcontainer"
    echo "  $0 --logs            # Show container logs"
    echo "  $0 --status          # Show container status"
}

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check if Docker is running
    if ! docker info >/dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
    
    # Check if Cursor is installed
    if ! command -v cursor >/dev/null 2>&1; then
        print_warning "Cursor CLI not found. You may need to install Cursor IDE."
        print_status "You can still open the DevContainer folder manually in Cursor IDE."
    fi
    
    # Check if devcontainer.json exists
    if [ ! -f "DevContainer/devcontainer.json" ]; then
        print_error "devcontainer.json not found. Please run this script from the project root."
        exit 1
    fi
    
    print_success "Prerequisites check passed."
}

# Function to build container
build_container() {
    local clean_build=$1
    
    print_status "Building TypeScript Excel devcontainer..."
    
    cd DevContainer
    
    if [ "$clean_build" = true ]; then
        print_status "Performing clean build..."
        docker build --no-cache -t typescript-excel-dev .
    else
        docker build -t typescript-excel-dev .
    fi
    
    if [ $? -eq 0 ]; then
        print_success "Container built successfully."
    else
        print_error "Failed to build container."
        exit 1
    fi
    
    cd ..
}

# Function to show container status
show_status() {
    print_status "Container status:"
    
    # Show running containers
    echo "Running containers:"
    docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"
    
    echo ""
    
    # Show all containers (including stopped)
    echo "All containers:"
    docker ps -a --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"
    
    echo ""
    
    # Show images
    echo "Available images:"
    docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedAt}}\t{{.Size}}"
}

# Function to show container logs
show_logs() {
    local container_id=$(docker ps -q --filter "ancestor=typescript-excel-dev")
    
    if [ -z "$container_id" ]; then
        print_warning "No running TypeScript Excel devcontainer found."
        print_status "Available containers:"
        docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"
        return 1
    fi
    
    print_status "Showing logs for container: $container_id"
    docker logs -f "$container_id"
}

# Function to open devcontainer
open_devcontainer() {
    print_status "Opening TypeScript Excel devcontainer in Cursor IDE..."
    
    # Get the absolute path of the current directory
    WORKSPACE_PATH=$(pwd)
    DEVCONTAINER_PATH="$WORKSPACE_PATH/DevContainer/devcontainer.json"
    
    # Check if devcontainer.json exists
    if [ ! -f "$DEVCONTAINER_PATH" ]; then
        print_error "devcontainer.json not found at $DEVCONTAINER_PATH"
        exit 1
    fi
    
    # Create the configuration
    CONF="{\"settingType\":\"config\", \"workspacePath\":\"$WORKSPACE_PATH\", \"devcontainerPath\":\"$DEVCONTAINER_PATH\"}"
    HEX_CONF=$(printf "$CONF" | od -A n -t x1 | tr -d '[\n\t ]')
    
    print_status "Configuration:"
    echo "  Workspace: $WORKSPACE_PATH"
    echo "  DevContainer: $DEVCONTAINER_PATH"
    echo "  Target: /workspaces"
    
    # Check if Cursor CLI is available
    if command -v cursor >/dev/null 2>&1; then
        print_status "Opening in Cursor IDE..."
        cursor --folder-uri "vscode-remote://dev-container+${HEX_CONF}/workspaces"
    else
        print_warning "Cursor CLI not found. Please open the DevContainer folder manually in Cursor IDE."
        print_status "Path: $WORKSPACE_PATH/DevContainer"
        print_status "Then click 'Reopen in Container' when prompted."
    fi
}

# Function to clean up Docker resources
cleanup_docker() {
    print_status "Cleaning up Docker resources..."
    
    # Remove stopped containers
    docker container prune -f
    
    # Remove unused images
    docker image prune -f
    
    # Remove unused volumes
    docker volume prune -f
    
    print_success "Docker cleanup completed."
}

# Main function
main() {
    local build=false
    local clean_build=false
    local show_logs_flag=false
    local show_status_flag=false
    local cleanup=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -b|--build)
                build=true
                shift
                ;;
            -c|--clean)
                clean_build=true
                build=true
                shift
                ;;
            -l|--logs)
                show_logs_flag=true
                shift
                ;;
            -s|--status)
                show_status_flag=true
                shift
                ;;
            --cleanup)
                cleanup=true
                shift
                ;;
            -*)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
            *)
                print_error "Unknown argument: $1"
                show_usage
                exit 1
                ;;
        esac
    done
    
    # Check prerequisites
    check_prerequisites
    
    # Handle different operations
    if [ "$cleanup" = true ]; then
        cleanup_docker
        exit 0
    fi
    
    if [ "$show_status_flag" = true ]; then
        show_status
        exit 0
    fi
    
    if [ "$show_logs_flag" = true ]; then
        show_logs
        exit 0
    fi
    
    # Build container if requested
    if [ "$build" = true ]; then
        build_container "$clean_build"
    fi
    
    # Open devcontainer
    open_devcontainer
}

# Run main function with all arguments
main "$@"


