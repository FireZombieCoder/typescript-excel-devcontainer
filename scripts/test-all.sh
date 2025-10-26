#!/bin/bash

# Test All Projects Script
# This script runs tests for all TypeScript Excel projects in the workspace

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

# Function to test a project
test_project() {
    local project_path=$1
    local project_name=$(basename "$project_path")
    
    print_status "Testing project: $project_name"
    
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
    
    # Check if Jest is configured
    if ! grep -q "jest" package.json; then
        print_warning "No Jest configuration found in $project_path"
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
    
    # Run tests
    print_status "Running tests for $project_name..."
    if npm test; then
        print_success "All tests passed for $project_name"
        return 0
    else
        print_error "Some tests failed for $project_name"
        return 1
    fi
}

# Function to run tests with coverage
test_project_with_coverage() {
    local project_path=$1
    local project_name=$(basename "$project_path")
    
    print_status "Testing project with coverage: $project_name"
    
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
    
    # Check if Jest is configured
    if ! grep -q "jest" package.json; then
        print_warning "No Jest configuration found in $project_path"
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
    
    # Run tests with coverage
    print_status "Running tests with coverage for $project_name..."
    if npm run test:coverage; then
        print_success "All tests passed with coverage for $project_name"
        return 0
    else
        print_error "Some tests failed for $project_name"
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
    echo "  -a, --all      Test all projects (default)"
    echo "  -c, --coverage Run tests with coverage"
    echo "  -w, --watch    Run tests in watch mode"
    echo "  -v, --verbose  Verbose output"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Test all projects"
    echo "  $0 --coverage                        # Test all projects with coverage"
    echo "  $0 --watch                           # Test all projects in watch mode"
    echo "  $0 /workspaces/my-project            # Test specific project"
    echo "  $0 /workspaces/project1 /workspaces/project2  # Test multiple projects"
}

# Main function
main() {
    local coverage=false
    local watch=false
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
            -c|--coverage)
                coverage=true
                shift
                ;;
            -w|--watch)
                watch=true
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
        print_warning "No projects found to test"
        exit 0
    fi
    
    print_status "Found ${#projects[@]} project(s) to test"
    
    # Test projects
    local success_count=0
    local failure_count=0
    
    for project in "${projects[@]}"; do
        if [ "$coverage" = true ]; then
            if test_project_with_coverage "$project"; then
                ((success_count++))
            else
                ((failure_count++))
            fi
        elif [ "$watch" = true ]; then
            print_status "Starting watch mode for $project"
            cd "$project"
            npm run test:watch &
            ((success_count++))
        else
            if test_project "$project"; then
                ((success_count++))
            else
                ((failure_count++))
            fi
        fi
    done
    
    # Summary
    if [ "$watch" = false ]; then
        echo ""
        print_status "Test Summary:"
        print_success "Successful tests: $success_count"
        if [ $failure_count -gt 0 ]; then
            print_error "Failed tests: $failure_count"
        fi
        
        if [ $failure_count -gt 0 ]; then
            exit 1
        fi
    fi
}

# Run main function with all arguments
main "$@"
