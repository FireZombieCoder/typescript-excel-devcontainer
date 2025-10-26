# Dev Container Usage Guide

This guide explains how to use the Dev Containers extension in Cursor IDE and initialize the TypeScript Excel development environment via command-line.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Using Dev Containers in Cursor IDE](#using-dev-containers-in-cursor-ide)
- [Command-Line Usage](#command-line-usage)
- [Troubleshooting](#troubleshooting)
- [Security Considerations](#security-considerations)

## Overview

The Dev Containers extension enables you to use Docker containers as your development environment. It provides a consistent, isolated workspace with all the tools and dependencies needed for TypeScript Excel development.

### What This Extension Does

- Runs your development environment inside a Docker container
- Mounts your workspace files into the container
- Installs and runs extensions inside the container
- Provides seamless integration with Cursor as if everything were running locally

## Prerequisites

### Docker Installation Options

You can use Docker in several ways:
- Local Docker installation
- Remote Docker environment
- Other Docker-compliant CLIs (unofficially supported)
- Kubernetes pods (requires kubectl)

### System Requirements

#### Local Docker Setup

**Windows:**
- Docker Desktop with WSL2 Backend

**macOS:**
- Docker Desktop

**Linux:**
- Docker CE/EE 18.06+
- Docker Compose 1.21+
- **Note:** Ubuntu snap package is not supported

#### Supported Container Systems

- Debian 9+
- Ubuntu 16.04+
- CentOS / RHEL 7+
- Alpine Linux
- x86_64 and arm64 architectures are supported

## Installation

### Windows / macOS Setup

1. **Install Docker Desktop**
2. **For Windows - Ensure that WSL2 is enabled:**
   - Open Docker Desktop settings
   - Enable "Use the WSL2 based engine"
   - Verify your distribution under Resources > WSL Integration

### Linux Setup

1. **Install Docker CE/EE** following official instructions
2. **Install Docker Compose** if needed
3. **Add your user to the docker group:**
   ```bash
   sudo usermod -aG docker $USER
   ```
4. **Sign out and back in** for changes to take effect

### Git Integration Tips

- **For Windows users:** Configure consistent line endings when working with the same repository in both container and Windows
- Git credentials are automatically shared with containers
- SSH keys can be shared with containers (see Sharing Git credentials)

### Alpine Linux Support

- Requires Cursor v0.50.5 or newer
- Required packages: bash, libstdc++, and wget
- Add to your Dockerfile:
  ```dockerfile
  RUN apk add --no-cache bash libstdc++ wget
  ```

## Using Dev Containers in Cursor IDE

### Method 1: Automatic Detection (Recommended)

1. **Open the DevContainer folder in Cursor IDE:**
   ```bash
   cursor DevContainer
   ```

2. **Cursor will automatically detect the devcontainer configuration:**
   - Look for the notification: "Folder contains a Dev Container configuration file"
   - Click "Reopen in Container" when prompted

3. **Wait for the container to build:**
   - First build may take 5-10 minutes
   - All dependencies will be automatically installed
   - VS Code extensions will be installed automatically

### Method 2: Manual Command

1. **Open Cursor IDE**
2. **Press Ctrl+Shift+P** (or Cmd+Shift+P on macOS)
3. **Type "Dev Containers: Reopen in Container"**
4. **Select the command** and wait for the container to build

### Method 3: Command Palette

1. **Open the DevContainer folder**
2. **Press Ctrl+Shift+P** (or Cmd+Shift+P on macOS)
3. **Type "Dev Containers: Open Folder in Container"**
4. **Select the DevContainer folder**

## Command-Line Usage

### Opening Remote Containers via CLI

You can open workspaces in a remote container directly via the cursor CLI:

```bash
cursor --folder-uri vscode-remote://<authority>+<spec>[@(wsl|ssh-remote)+<nested spec>]/<folder path>
```

The authority can be either `attached-container`, `dev-container`, or `k8s-container`, depending on which type of container you're connecting to.

### Dev Containers (Our Use Case)

The schema for the spec is:
```json
{
  "settingType": "config",
  "workspacePath": "string",
  "devcontainerPath": "string"
}
```

#### Example: Open TypeScript Excel Devcontainer

```bash
# Configuration for our TypeScript Excel devcontainer
CONF='{"settingType":"config", "workspacePath": "/home/acer_vm/Projects/Devcontainers", "devcontainerPath": "/home/acer_vm/Projects/Devcontainers/DevContainer/devcontainer.json"}'
HEX_CONF=$(printf "$CONF" | od -A n -t x1 | tr -d '[\n\t ]')
cursor --folder-uri "vscode-remote://dev-container+${HEX_CONF}/workspaces"
```

#### Example: Using Relative Paths

```bash
# From the project root directory
CONF='{"settingType":"config", "workspacePath": ".", "devcontainerPath": "./DevContainer/devcontainer.json"}'
HEX_CONF=$(printf "$CONF" | od -A n -t x1 | tr -d '[\n\t ]')
cursor --folder-uri "vscode-remote://dev-container+${HEX_CONF}/workspaces"
```

### Attached Containers

The schema for the spec is:
```json
{
  "settingType": "container",
  "containerId": "string"
}
```

#### Example: Connect to Running Container

```bash
# First, find your container ID
docker ps

# Then connect to it
CONF='{"settingType":"container", "containerId": "6021b49999b7"}'
HEX_CONF=$(printf "$CONF" | od -A n -t x1 | tr -d '[\n\t ]')
cursor --folder-uri "vscode-remote://attached-container+${HEX_CONF}/workspaces"
```

### Kubernetes Pods

The schema for the spec is:
```json
{
  "settingType": "pod",
  "podname": "string",
  "name": "string",
  "context": "string",
  "namespace": "string"
}
```

#### Example: Connect to Kubernetes Pod

```bash
CONF='{"settingType":"pod", "podname": "ubuntu", "name": "ubuntu", "context": "docker-desktop", "namespace": "default"}'
HEX_CONF=$(printf "$CONF" | od -A n -t x1 | tr -d '[\n\t ]')
cursor --folder-uri "vscode-remote://k8s-container+${HEX_CONF}/workspaces"
```

### Nested Containers

#### Over WSL (Windows Subsystem for Linux)

```bash
CONF='{"settingType":"config", "workspacePath": "/home/user/repo", "devcontainerPath": "/home/user/repo/.devcontainer/devcontainer.json"}'
HEX_CONF=$(printf "$CONF" | od -A n -t x1 | tr -d '[\n\t ]')
cursor --folder-uri "vscode-remote://dev-container+${HEX_CONF}@wsl+Ubuntu-24.04/workspaces/repo"
```

#### Over SSH

```bash
CONF='{"settingType":"config", "workspacePath": "/home/user/repo", "devcontainerPath": "/home/user/repo/.devcontainer/devcontainer.json"}'
HEX_CONF=$(printf "$CONF" | od -A n -t x1 | tr -d '[\n\t ]')
cursor --folder-uri "vscode-remote://dev-container+${HEX_CONF}@ssh-remote+loginnode/workspaces/repo"
```

#### Over SSH with Full Connection String

```bash
DOCKER_CONF='{"settingType":"config", "workspacePath": "/home/user/repo", "devcontainerPath": "/home/user/repo/.devcontainer/devcontainer.json"}'
DOCKER_HEX_CONF=$(printf "$DOCKER_CONF" | od -A n -t x1 | tr -d '[\n\t ]')
SSH_CONF='{"hostName":"user@76.76.21.21 -p 22"}'
SSH_HEX_CONF=$(printf "$SSH_CONF" | od -A n -t x1 | tr -d '[\n\t ]')
cursor --folder-uri "vscode-remote://dev-container+${DOCKER_HEX_CONF}@ssh-remote+${SSH_HEX_CONF}/workspaces/repo"
```

## Quick Start Scripts

### Create a Helper Script

Create a script to easily open the devcontainer:

```bash
#!/bin/bash
# File: open-devcontainer.sh

# Get the absolute path of the current directory
WORKSPACE_PATH=$(pwd)
DEVCONTAINER_PATH="$WORKSPACE_PATH/DevContainer/devcontainer.json"

# Check if devcontainer.json exists
if [ ! -f "$DEVCONTAINER_PATH" ]; then
    echo "Error: devcontainer.json not found at $DEVCONTAINER_PATH"
    exit 1
fi

# Create the configuration
CONF="{\"settingType\":\"config\", \"workspacePath\":\"$WORKSPACE_PATH\", \"devcontainerPath\":\"$DEVCONTAINER_PATH\"}"
HEX_CONF=$(printf "$CONF" | od -A n -t x1 | tr -d '[\n\t ]')

# Open in Cursor
cursor --folder-uri "vscode-remote://dev-container+${HEX_CONF}/workspaces"
```

Make it executable:
```bash
chmod +x open-devcontainer.sh
```

Usage:
```bash
./open-devcontainer.sh
```

### Docker Commands for Development

#### Build the Container Manually

```bash
cd DevContainer
docker build -t typescript-excel-dev .
```

#### Run the Container Interactively

```bash
docker run -it --rm -v $(pwd):/workspaces typescript-excel-dev
```

#### List Running Containers

```bash
docker ps
```

#### Stop All Containers

```bash
docker stop $(docker ps -q)
```

#### Clean Up Docker Resources

```bash
# Remove stopped containers
docker container prune

# Remove unused images
docker image prune

# Remove unused volumes
docker volume prune

# Remove everything (use with caution)
docker system prune -a
```

## Troubleshooting

### Common Issues

#### 1. Container Won't Start

**Symptoms:**
- Container fails to build
- Error messages about missing dependencies

**Solutions:**
```bash
# Check Docker is running
docker --version
docker ps

# Check available disk space
df -h

# Clear Docker cache and rebuild
docker system prune -a
cd DevContainer
docker build --no-cache -t typescript-excel-dev .
```

#### 2. Extensions Not Installing

**Symptoms:**
- VS Code extensions listed in devcontainer.json don't install
- Missing functionality in the container

**Solutions:**
1. Check extension IDs in devcontainer.json
2. Rebuild the container: `Ctrl+Shift+P` → "Dev Containers: Rebuild Container"
3. Check Cursor logs: Help → Toggle Developer Tools

#### 3. Permission Issues

**Symptoms:**
- Permission denied errors
- Files not writable

**Solutions:**
```bash
# Fix file permissions
sudo chown -R $USER:$USER .

# Check Docker group membership
groups $USER

# Add user to docker group if needed
sudo usermod -aG docker $USER
```

#### 4. Port Forwarding Issues

**Symptoms:**
- Can't access development server
- Ports not accessible

**Solutions:**
1. Check port forwarding in devcontainer.json
2. Verify ports are not in use: `netstat -tulpn | grep :3000`
3. Restart the container

### Debug Commands

#### Check Container Logs

```bash
# Get container ID
docker ps

# View logs
docker logs <container-id>

# Follow logs in real-time
docker logs -f <container-id>
```

#### Inspect Container

```bash
# Get detailed container information
docker inspect <container-id>

# Execute commands in running container
docker exec -it <container-id> /bin/bash
```

#### Check Devcontainer Configuration

```bash
# Validate devcontainer.json
cat DevContainer/devcontainer.json | jq .

# Check Dockerfile
cat DevContainer/Dockerfile
```

## Security Considerations

⚠️ **Security Warning**: Only connect to trusted containers. While Docker provides some isolation, it is not foolproof. A compromised remote system could potentially execute code on your local machine through the Remote Containers connection.

### Best Practices

1. **Use Official Images**: Prefer official base images when possible
2. **Regular Updates**: Keep Docker and container images updated
3. **Minimal Permissions**: Run containers with minimal required permissions
4. **Network Isolation**: Use Docker networks to isolate containers
5. **Resource Limits**: Set appropriate CPU and memory limits

### Network Security

```bash
# Create isolated network
docker network create --driver bridge excel-dev-network

# Run container on isolated network
docker run -it --rm --network excel-dev-network -v $(pwd):/workspaces typescript-excel-dev
```

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Dev Containers Documentation](https://containers.dev/)
- [Cursor IDE Documentation](https://cursor.sh/docs)
- [Office.js Documentation](https://docs.microsoft.com/en-us/office/dev/add-ins/)
- [TypeScript Documentation](https://www.typescriptlang.org/docs/)

## Support

If you encounter issues:

1. Check the troubleshooting section above
2. Review Docker and Cursor logs
3. Verify system requirements
4. Check the [troubleshooting guide](../troubleshooting.md)
5. Create an issue in the project repository

---

**Happy coding with TypeScript and Excel! 🚀**


