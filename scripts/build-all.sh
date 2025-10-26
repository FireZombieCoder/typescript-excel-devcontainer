#!/bin/bash

# Build All Projects Script
# This script builds all TypeScript Excel projects in the workspace

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

# Function to build a project
build_project() {
    local project_path=$1
    local project_name=$(basename "$project_path")
    
    print_status "Building project: $project_name"
    
    if [ ! -d "$project_path" ]; then
        print_warning "Project directory not found: $project_path"
        return 1
    fi
    
    cd "$project_path"
    
    # Check if package.json exists
    if [ ! -f "package.json" ]; then
        print_warning "No package.json found in $project_path"
        return 1
    fi
    
    # Check if node_modules exists
    if [ ! -d "node_modules" ]; then
        print_status "Installing dependencies for $project_name..."
        if ! npm install; then
            print_error "Failed to install dependencies for $project_name"
            return 1
        fi
    fi
    
    # Run build
    print_status "Running build for $project_name..."
    if npm run build; then
        print_success "Successfully built $project_name"
        return 0
    else
        print_error "Failed to build $project_name"
        return 1
    fi
}

# Function to find all projects
find_projects() {
    local projects=()
    
    # Find projects in examples directory
    if [ -d "/workspaces/examples" ]; then
        for project in /workspaces/examples/*; do
            if [ -d "$project" ] && [ -f "$project/package.json" ]; then
                projects+=("$project")
            fi
        done
    fi
    
    # Find projects in templates directory
    if [ -d "/workspaces/templates" ]; then
        for project in /workspaces/templates/*; do
            if [ -d "$project" ] && [ -f "$project/package.json" ]; then
                projects+=("$project")
            fi
        done
    fi
    
    # Find projects in workspace root
    for project in /workspaces/*; do
        if [ -d "$project" ] && [ -f "$project/package.json" ]; then
            # Skip if it's a known directory
            local basename=$(basename "$project")
            if [[ "$basename" != "examples" && "$basename" != "templates" && "$basename" != "docs" && "$basename" != "scripts" ]]; then
                projects+=("$project")
            fi
        fi
    done
    
    echo "${projects[@]}"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS] [PROJECT_PATHS...]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -a, --all      Build all projects (default)"
    echo "  -c, --clean    Clean build (remove dist directories first)"
    echo "  -v, --verbose  Verbose output"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Build all projects"
    echo "  $0 --clean                           # Clean build all projects"
    echo "  $0 /workspaces/my-project            # Build specific project"
    echo "  $0 /workspaces/project1 /workspaces/project2  # Build multiple projects"
}

# Main function
main() {
    local clean_build=false
    local verbose=false
    local projects=()
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_usage
                exit 0
                ;;
            -a|--all)
                projects=($(find_projects))
                shift
                ;;
            -c|--clean)
                clean_build=true
                shift
                ;;
            -v|--verbose)
                verbose=true
                shift
                ;;
            -*)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
            *)
                projects+=("$1")
                shift
                ;;
        esac
    done
    
    # If no projects specified, find all
    if [ ${#projects[@]} -eq 0 ]; then
        projects=($(find_projects))
    fi
    
    if [ ${#projects[@]} -eq 0 ]; then
        print_warning "No projects found to build"
        exit 0
    fi
    
    print_status "Found ${#projects[@]} project(s) to build"
    
    # Clean build if requested
    if [ "$clean_build" = true ]; then
        print_status "Performing clean build..."
        for project in "${projects[@]}"; do
            if [ -d "$project/dist" ]; then
                print_status "Cleaning $project/dist"
                rm -rf "$project/dist"
            fi
        done
    fi
    
    # Build projects
    local success_count=0
    local failure_count=0
    
    for project in "${projects[@]}"; do
        if build_project "$project"; then
            ((success_count++))
        else
            ((failure_count++))
        fi
    done
    
    # Summary
    echo ""
    print_status "Build Summary:"
    print_success "Successful builds: $success_count"
    if [ $failure_count -gt 0 ]; then
        print_error "Failed builds: $failure_count"
    fi
    
    if [ $failure_count -gt 0 ]; then
        exit 1
    fi
}

# Run main function with all arguments
main "$@"
