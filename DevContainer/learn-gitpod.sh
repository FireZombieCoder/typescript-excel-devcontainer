#!/bin/bash

# GitPod Learning Script
# Interactive tutorial for mastering GitPod development

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_header() {
    echo -e "${PURPLE}================================${NC}"
    echo -e "${PURPLE}$1${NC}"
    echo -e "${PURPLE}================================${NC}"
}

print_lesson() {
    echo -e "${CYAN}📚 LESSON $1: $2${NC}"
    echo ""
}

print_step() {
    echo -e "${BLUE}🔹 Step $1:${NC} $2"
}

print_tip() {
    echo -e "${YELLOW}💡 TIP:${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️  WARNING:${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅ SUCCESS:${NC} $1"
}

print_error() {
    echo -e "${RED}❌ ERROR:${NC} $1"
}

# Function to wait for user input
wait_for_user() {
    echo ""
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read -r
    echo ""
}

# Function to ask yes/no question
ask_yes_no() {
    while true; do
        echo -e "${YELLOW}$1 (y/n):${NC} "
        read -r response
        case $response in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Main learning script
main() {
    clear
    print_header "🚀 GITPOD LEARNING JOURNEY"
    echo ""
    echo "Welcome to the comprehensive GitPod learning experience!"
    echo "This interactive tutorial will teach you everything you need to know"
    echo "about GitPod and how to use it effectively with Cursor IDE."
    echo ""
    wait_for_user

    # Lesson 1: What is GitPod?
    print_lesson "1" "Understanding GitPod"
    echo "GitPod is a cloud-based development environment that provides:"
    echo ""
    print_step "1" "Instant Workspace Creation"
    echo "   • No local Docker installation required"
    echo "   • Workspaces start in seconds, not minutes"
    echo "   • Consistent environment every time"
    echo ""
    print_step "2" "Pre-configured Development Environments"
    echo "   • TypeScript, Python, Java, Go, and more"
    echo "   • Popular frameworks and tools pre-installed"
    echo "   • VS Code and other editors built-in"
    echo ""
    print_step "3" "Cloud-Powered Development"
    echo "   • More resources than your local machine"
    echo "   • Always-on workspaces (with paid plans)"
    echo "   • Easy sharing and collaboration"
    echo ""
    print_tip "GitPod is perfect for teams, open source projects, and learning!"
    wait_for_user

    # Lesson 2: GitPod vs Docker Desktop
    print_lesson "2" "GitPod vs Docker Desktop + WSL2"
    echo ""
    echo "Comparison table:"
    echo ""
    echo "┌─────────────────────┬─────────────────┬─────────────────┐"
    echo "│ Feature             │ Docker Desktop  │ GitPod          │"
    echo "├─────────────────────┼─────────────────┼─────────────────┤"
    echo "│ Setup Complexity    │ High            │ Low             │"
    echo "│ Resource Usage      │ High            │ Cloud-based     │"
    echo "│ Startup Time        │ 2-5 minutes     │ 10-30 seconds   │"
    echo "│ Reliability         │ Often breaks    │ Very stable     │"
    echo "│ Cross-platform      │ Windows issues  │ Works everywhere│"
    echo "│ Sharing             │ Difficult       │ One-click       │"
    echo "│ Cost                │ Free (limited)  │ Free tier + paid│"
    echo "│ Offline Development │ Yes             │ No              │"
    echo "└─────────────────────┴─────────────────┴─────────────────┘"
    echo ""
    print_tip "GitPod wins for most development scenarios, especially team work!"
    wait_for_user

    # Lesson 3: Setting up GitPod
    print_lesson "3" "Setting up GitPod"
    echo ""
    print_step "1" "Create GitPod Account"
    echo "   • Go to https://gitpod.io"
    echo "   • Sign up with GitHub, GitLab, or Bitbucket"
    echo "   • Connect your repository hosting service"
    echo ""
    print_step "2" "Add .gitpod.yml to Your Project"
    echo "   • This file configures your workspace"
    echo "   • Defines environment, ports, and tasks"
    echo "   • We'll create this for you automatically"
    echo ""
    print_step "3" "Open Your First Workspace"
    echo "   • Go to your repository on GitHub"
    echo "   • Click the 'GitPod' button"
    echo "   • Or use: https://gitpod.io/#your-repo-url"
    echo ""
    
    if ask_yes_no "Do you want to set up GitPod for this project now?"; then
        print_step "4" "Running Migration Script"
        if [ -f "migrate-to-gitpod.sh" ]; then
            echo "Running migration script..."
            ./migrate-to-gitpod.sh
            print_success "GitPod configuration created!"
        else
            print_error "Migration script not found. Please run it manually."
        fi
    fi
    wait_for_user

    # Lesson 4: GitPod Configuration
    print_lesson "4" "Understanding .gitpod.yml"
    echo ""
    echo "The .gitpod.yml file controls your workspace:"
    echo ""
    print_step "1" "Image Selection"
    echo "   • gitpod/workspace-full:latest (most complete)"
    echo "   • gitpod/workspace-base:latest (minimal)"
    echo "   • Custom Docker images"
    echo ""
    print_step "2" "Port Configuration"
    echo "   • Expose ports for web applications"
    echo "   • Automatic port forwarding"
    echo "   • Public URL generation"
    echo ""
    print_step "3" "Tasks and Commands"
    echo "   • init: Run once when workspace starts"
    echo "   • command: Run every time workspace opens"
    echo "   • before: Run before other tasks"
    echo ""
    print_step "4" "VS Code Extensions"
    echo "   • Automatically install extensions"
    echo "   • Configure workspace settings"
    echo "   • Set up debugging"
    echo ""
    print_tip "Check the generated .gitpod.yml file to see these in action!"
    wait_for_user

    # Lesson 5: Cursor IDE Integration
    print_lesson "5" "Integrating with Cursor IDE"
    echo ""
    print_step "1" "Install GitPod Extension"
    echo "   • Open Cursor IDE"
    echo "   • Go to Extensions (Ctrl+Shift+X)"
    echo "   • Search for 'GitPod'"
    echo "   • Install the official extension"
    echo ""
    print_step "2" "Connect to GitPod Workspace"
    echo "   • Use Command Palette (Ctrl+Shift+P)"
    echo "   • Type 'GitPod: Open in GitPod'"
    echo "   • Select your repository"
    echo "   • Workspace opens in browser"
    echo ""
    print_step "3" "Alternative: Remote Development"
    echo "   • Install 'Remote - SSH' extension"
    echo "   • Connect to GitPod via SSH"
    echo "   • Use Cursor directly in GitPod"
    echo ""
    print_tip "The GitPod extension provides the smoothest experience!"
    wait_for_user

    # Lesson 6: GitPod Workflow
    print_lesson "6" "GitPod Development Workflow"
    echo ""
    print_step "1" "Daily Workflow"
    echo "   • Open GitPod workspace"
    echo "   • Code in Cursor IDE (connected)"
    echo "   • Test in GitPod browser"
    echo "   • Commit and push changes"
    echo ""
    print_step "2" "Collaboration"
    echo "   • Share workspace URL with team"
    echo "   • Real-time collaboration"
    echo "   • Shared debugging sessions"
    echo ""
    print_step "3" "Project Management"
    echo "   • Create branches in GitPod"
    echo "   • Open pull requests"
    echo "   • Review code in browser"
    echo ""
    print_step "4" "Deployment"
    echo "   • Deploy directly from GitPod"
    echo "   • Use GitPod's built-in CI/CD"
    echo "   • Connect to cloud providers"
    echo ""
    print_tip "GitPod workspaces persist your changes automatically!"
    wait_for_user

    # Lesson 7: Advanced GitPod Features
    print_lesson "7" "Advanced GitPod Features"
    echo ""
    print_step "1" "Prebuilds"
    echo "   • Pre-build workspaces for faster startup"
    echo "   • Configure in .gitpod.yml"
    echo "   • Perfect for large projects"
    echo ""
    print_step "2" "Snapshots"
    echo "   • Save workspace state"
    echo "   • Share exact environment"
    echo "   • Resume work later"
    echo ""
    print_step "3" "Custom Images"
    echo "   • Build your own Docker images"
    echo "   • Include specific tools"
    echo "   • Share across team"
    echo ""
    print_step "4" "Environment Variables"
    echo "   • Secure secret storage"
    echo "   • Per-workspace configuration"
    echo "   • Integration with external services"
    echo ""
    print_tip "Advanced features make GitPod perfect for enterprise development!"
    wait_for_user

    # Lesson 8: Troubleshooting
    print_lesson "8" "Troubleshooting Common Issues"
    echo ""
    print_step "1" "Workspace Won't Start"
    echo "   • Check .gitpod.yml syntax"
    echo "   • Verify image exists"
    echo "   • Check resource limits"
    echo ""
    print_step "2" "Port Not Accessible"
    echo "   • Verify port configuration"
    echo "   • Check if service is running"
    echo "   • Try different port number"
    echo ""
    print_step "3" "Extensions Not Installing"
    echo "   • Check extension IDs"
    echo "   • Verify marketplace access"
    echo "   • Try manual installation"
    echo ""
    print_step "4" "Performance Issues"
    echo "   • Check workspace resources"
    echo "   • Optimize .gitpod.yml"
    echo "   • Consider prebuilds"
    echo ""
    print_tip "GitPod has excellent documentation and community support!"
    wait_for_user

    # Lesson 9: Best Practices
    print_lesson "9" "GitPod Best Practices"
    echo ""
    print_step "1" "Configuration"
    echo "   • Keep .gitpod.yml simple"
    echo "   • Use official images when possible"
    echo "   • Document custom configurations"
    echo ""
    print_step "2" "Development"
    echo "   • Use branches for features"
    echo "   • Commit changes frequently"
    echo "   • Use snapshots for important states"
    echo ""
    print_step "3" "Team Work"
    echo "   • Share workspace URLs"
    echo "   • Use consistent configurations"
    echo "   • Document setup procedures"
    echo ""
    print_step "4" "Security"
    echo "   • Use environment variables for secrets"
    echo "   • Don't commit sensitive data"
    echo "   • Review workspace permissions"
    echo ""
    print_tip "Following best practices ensures smooth team collaboration!"
    wait_for_user

    # Lesson 10: Next Steps
    print_lesson "10" "Your Next Steps"
    echo ""
    print_step "1" "Immediate Actions"
    echo "   • Set up your GitPod account"
    echo "   • Run the migration script"
    echo "   • Test your first workspace"
    echo ""
    print_step "2" "Learning Resources"
    echo "   • GitPod Documentation: https://www.gitpod.io/docs"
    echo "   • GitPod Community: https://community.gitpod.io"
    echo "   • YouTube Tutorials: Search 'GitPod tutorial'"
    echo ""
    print_step "3" "Practice Projects"
    echo "   • Try different project types"
    echo "   • Experiment with configurations"
    echo "   • Share workspaces with others"
    echo ""
    print_step "4" "Advanced Topics"
    echo "   • Custom Docker images"
    echo "   • CI/CD integration"
    echo "   • Enterprise features"
    echo ""
    print_tip "The best way to learn GitPod is by using it regularly!"
    wait_for_user

    # Final summary
    print_header "🎉 CONGRATULATIONS!"
    echo ""
    echo "You've completed the GitPod learning journey!"
    echo ""
    echo "What you've learned:"
    echo "✅ What GitPod is and why it's better than Docker Desktop"
    echo "✅ How to set up GitPod for your projects"
    echo "✅ How to integrate with Cursor IDE"
    echo "✅ GitPod development workflow"
    echo "✅ Advanced features and best practices"
    echo "✅ Troubleshooting common issues"
    echo ""
    echo "Ready to start using GitPod?"
    echo ""
    if ask_yes_no "Would you like to open your first GitPod workspace now?"; then
        if [ -f "quick-start-gitpod.sh" ]; then
            echo "Opening GitPod workspace..."
            ./quick-start-gitpod.sh
        else
            print_error "Quick start script not found. Please run migrate-to-gitpod.sh first."
        fi
    fi
    
    echo ""
    print_success "Happy coding with GitPod! 🚀"
    echo ""
    echo "Need help? Check out:"
    echo "📚 Documentation: https://www.gitpod.io/docs"
    echo "💬 Community: https://community.gitpod.io"
    echo "🐛 Issues: https://github.com/gitpod-io/gitpod/issues"
    echo ""
}

# Run the main function
main "$@"
