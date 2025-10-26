# DevContainer Troubleshooting Guide

## Common Issues and Solutions

### 1. Docker Not Available in Gitpod

**Problem**: Docker is not available in the Gitpod environment, causing DevContainer rebuild failures.

**Solution**: 
- Gitpod doesn't support Docker-in-Docker by default
- Use the pre-built Microsoft DevContainer images instead of custom Dockerfiles
- Updated `devcontainer.json` to use `mcr.microsoft.com/devcontainers/base:ubuntu-24.04` with features

### 2. DevContainer JSON Syntax Errors

**Problem**: Invalid JSON syntax in `devcontainer.json` causing parsing errors.

**Solution**:
- Fixed JSON syntax errors (missing commas, invalid comments)
- Removed invalid comment syntax
- Used proper JSON structure with features instead of custom Dockerfile

### 3. Missing Dependencies

**Problem**: DevContainer missing TypeScript, Node.js, and Office.js tools.

**Solution**:
- Added Node.js 20 feature to devcontainer.json
- Added comprehensive VS Code extensions for Office.js development
- Updated package.json with all required dependencies

### 4. Port Forwarding Issues

**Problem**: Ports not properly exposed or forwarded.

**Solution**:
- Added `forwardPorts` configuration for ports 3000, 8080, 9229
- Added `portsAttributes` with proper labels and auto-forward settings
- Configured ports to match Gitpod configuration

### 5. Workspace Mount Issues

**Problem**: Workspace not properly mounted in DevContainer.

**Solution**:
- Added proper `workspaceFolder` configuration
- Added `mounts` configuration for workspace binding
- Set correct `remoteUser` to vscode

## Updated Configuration

### DevContainer Configuration
```json
{
  "name": "TypeScript Excel DevContainer",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu-24.04",
  "features": {
    "ghcr.io/devcontainers/features/node:1": {
      "version": "20"
    },
    "ghcr.io/devcontainers/features/git:1": {},
    "ghcr.io/devcontainers/features/github-cli:1": {}
  },
  "customizations": {
    "vscode": {
      "extensions": [
        // 20+ Office.js and TypeScript extensions
      ],
      "settings": {
        // Comprehensive VS Code settings
      }
    }
  },
  "forwardPorts": [3000, 8080, 9229],
  "portsAttributes": {
    "3000": {
      "label": "Dev Server",
      "onAutoForward": "openPreview"
    },
    "8080": {
      "label": "Office Add-in", 
      "onAutoForward": "openPreview"
    },
    "9229": {
      "label": "Debug Port",
      "onAutoForward": "silent"
    }
  },
  "postCreateCommand": "bash scripts/gitpod-setup.sh",
  "remoteUser": "vscode",
  "workspaceFolder": "/workspace",
  "mounts": [
    "source=${localWorkspaceFolder},target=/workspace,type=bind,consistency=cached"
  ]
}
```

### Package.json Dependencies
- Added comprehensive dependencies for Office.js development
- Added all required devDependencies for TypeScript, webpack, testing
- Added proper scripts for development workflow
- Set Node.js engine requirements

## Testing the Configuration

### 1. Test DevContainer Build
```bash
# In VS Code with Dev Containers extension
# Command Palette: "Dev Containers: Rebuild Container"
```

### 2. Test Gitpod Environment
```bash
# Open in Gitpod
# Should automatically run setup script
```

### 3. Test Port Forwarding
```bash
# Check if ports are accessible
curl http://localhost:3000
curl http://localhost:8080
```

### 4. Test Dependencies
```bash
# Check Node.js version
node --version

# Check TypeScript
tsc --version

# Check Office.js tools
office-addin-validator --version
```

## Troubleshooting Commands

### Check DevContainer Status
```bash
# List running containers
docker ps

# Check DevContainer logs
docker logs <container-id>
```

### Check Port Status
```bash
# Check if ports are listening
netstat -tlnp | grep -E ':(3000|8080|9229)'
```

### Check Dependencies
```bash
# Check installed packages
npm list -g

# Check TypeScript configuration
tsc --showConfig
```

### Check VS Code Extensions
```bash
# List installed extensions
code --list-extensions
```

## Best Practices

1. **Use Features Instead of Custom Dockerfiles**: More reliable and faster
2. **Consistent Configuration**: Keep Gitpod and DevContainer configs aligned
3. **Proper Port Forwarding**: Always configure ports with labels
4. **Comprehensive Dependencies**: Include all required tools in package.json
5. **Post-Create Commands**: Use setup scripts for environment initialization
6. **Error Handling**: Add proper error handling in setup scripts
7. **Documentation**: Keep troubleshooting guides updated

## Support

If you encounter issues not covered in this guide:

1. Check the DevContainer logs
2. Verify all dependencies are installed
3. Test in both Gitpod and local DevContainer
4. Check VS Code extension compatibility
5. Review the official DevContainer documentation

## References

- [DevContainer Specification](https://containers.dev/)
- [VS Code Dev Containers](https://code.visualstudio.com/docs/remote/containers)
- [Gitpod Documentation](https://www.gitpod.io/docs)
- [Office.js Development](https://docs.microsoft.com/en-us/office/dev/add-ins/)
