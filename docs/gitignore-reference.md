# GitIgnore Reference Guide

This guide explains the comprehensive `.gitignore`, `.gitattributes`, and `.dockerignore` files used in this TypeScript Excel devcontainer project.

## Table of Contents

- [Overview](#overview)
- [.gitignore Categories](#gitignore-categories)
- [.gitattributes Configuration](#gitattributes-configuration)
- [.dockerignore Optimization](#dockerignore-optimization)
- [Project-Specific Rules](#project-specific-rules)
- [Best Practices](#best-practices)

## Overview

The project includes three configuration files to optimize Git and Docker operations:

- **`.gitignore`** - Tells Git which files to ignore
- **`.gitattributes`** - Controls line ending normalization and file handling
- **`.dockerignore`** - Optimizes Docker builds by excluding unnecessary files

## .gitignore Categories

### Node.js and JavaScript
```gitignore
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
pnpm-debug.log*

# Build outputs
dist/
build/
out/
coverage/

# TypeScript
*.tsbuildinfo
```

### IDE and Editor Files
```gitignore
# VS Code
.vscode/
*.code-workspace

# IntelliJ/WebStorm
.idea/
*.iml

# Sublime Text
*.sublime-project
*.sublime-workspace

# Vim/Emacs
*.swp
*.swo
*~
```

### Operating System Files
```gitignore
# macOS
.DS_Store
.AppleDouble
.LSOverride

# Windows
Thumbs.db
ehthumbs.db
Desktop.ini

# Linux
*~
```

### Environment and Configuration
```gitignore
# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Configuration overrides
config.local.js
config.local.json
settings.local.json
```

### Office Add-in Specific
```gitignore
# Office files
*.xlsx
*.xls
*.csv
*.manifest.xml
*.webmanifest

# Excel Add-in specific
*.xlsx
*.xls
*.csv
```

### Project Structure
```gitignore
# Keep project structure but ignore build artifacts
projects/*/node_modules/
projects/*/dist/
projects/*/build/
projects/*/coverage/

# Keep templates but ignore their build artifacts
templates/*/dist/
templates/*/build/
templates/*/coverage/
templates/*/node_modules/

# Keep examples but ignore their build artifacts
examples/*/dist/
examples/*/build/
examples/*/coverage/
examples/*/node_modules/
```

## .gitattributes Configuration

### Line Ending Normalization
```gitattributes
# Set default behavior to automatically normalize line endings
* text=auto

# Force Unix line endings for shell scripts
*.sh text eol=lf
*.bash text eol=lf

# Force Windows line endings for batch files
*.bat text eol=crlf
*.cmd text eol=crlf
```

### File Type Handling
```gitattributes
# Text files with Unix line endings
*.json text eol=lf
*.js text eol=lf
*.ts text eol=lf
*.html text eol=lf
*.css text eol=lf
*.md text eol=lf

# Binary files
*.png binary
*.jpg binary
*.jpeg binary
*.gif binary
*.ico binary
*.zip binary
*.tar.gz binary
```

### Large Files (Git LFS)
```gitattributes
# Large design files
*.psd filter=lfs diff=lfs merge=lfs -text
*.ai filter=lfs diff=lfs merge=lfs -text
*.sketch filter=lfs diff=lfs merge=lfs -text
```

## .dockerignore Optimization

### Excluded from Docker Build
```dockerignore
# Git files
.git
.gitignore
.gitattributes

# Documentation
README.md
docs/
*.md

# Node.js
node_modules/
npm-debug.log*

# Build outputs
dist/
build/
out/
coverage/

# IDE files
.vscode/
.idea/

# OS files
.DS_Store
Thumbs.db

# Environment files
.env
.env.*

# Project artifacts
projects/*/node_modules/
projects/*/dist/
projects/*/build/
```

### Kept in Docker Build
```dockerignore
# Essential files
!DevContainer/
!scripts/
!package.json
!package-lock.json
```

## Project-Specific Rules

### DevContainer Environment
- Ignores build artifacts in `projects/`, `templates/`, and `examples/` directories
- Keeps source code and configuration files
- Excludes IDE and OS-specific files

### TypeScript Excel Development
- Ignores Office file types (`.xlsx`, `.xls`, `.csv`)
- Excludes manifest and webmanifest files
- Handles Node.js and npm artifacts

### Cross-Platform Development
- Normalizes line endings for different operating systems
- Handles Windows, macOS, and Linux specific files
- Ensures consistent behavior across platforms

## Best Practices

### 1. Regular Review
- Review `.gitignore` regularly to ensure it covers new file types
- Remove unnecessary rules that are no longer relevant
- Test with `git status --ignored` to verify rules work correctly

### 2. Project-Specific Ignores
- Use project-specific `.gitignore` files in subdirectories when needed
- Document any special ignore rules in project README files
- Consider using `.gitignore` templates for new projects

### 3. Docker Optimization
- Keep `.dockerignore` minimal but effective
- Only exclude files that are truly unnecessary for the build
- Test Docker builds to ensure all required files are included

### 4. Line Ending Consistency
- Use `.gitattributes` to enforce consistent line endings
- Test on different operating systems to ensure compatibility
- Consider using pre-commit hooks to enforce line ending rules

### 5. Large File Management
- Use Git LFS for large binary files
- Document LFS usage in project documentation
- Monitor repository size and LFS usage

## Common Commands

### Check Ignored Files
```bash
# Show ignored files
git status --ignored

# Check if a specific file is ignored
git check-ignore -v path/to/file

# List all ignored files
git ls-files --others --ignored --exclude-standard
```

### Force Add Ignored Files
```bash
# Force add a file that's normally ignored
git add -f path/to/file

# Force add all files (use with caution)
git add -f .
```

### Test GitAttributes
```bash
# Check line ending normalization
git ls-files --eol

# Test attribute processing
git check-attr -a path/to/file
```

### Docker Build Testing
```bash
# Test Docker build with current .dockerignore
docker build -t test-image .

# Check what files are being sent to Docker daemon
docker build --no-cache -t test-image . 2>&1 | grep "Sending build context"
```

## Troubleshooting

### Files Still Being Tracked
1. Check if the file was already tracked before adding to `.gitignore`
2. Use `git rm --cached filename` to untrack without deleting
3. Verify `.gitignore` syntax and placement

### Line Ending Issues
1. Check `.gitattributes` configuration
2. Use `git config core.autocrlf` to verify settings
3. Consider using `git add --renormalize .` to fix line endings

### Docker Build Issues
1. Verify `.dockerignore` syntax
2. Check if required files are being excluded
3. Test with `docker build --no-cache` to see full context

## Additional Resources

- [Git Ignore Documentation](https://git-scm.com/docs/gitignore)
- [Git Attributes Documentation](https://git-scm.com/docs/gitattributes)
- [Docker Ignore Documentation](https://docs.docker.com/engine/reference/builder/#dockerignore-file)
- [Git LFS Documentation](https://git-lfs.github.io/)

---

**Note**: These configuration files are designed to work well with the TypeScript Excel devcontainer environment. Adjust them as needed for your specific project requirements.
