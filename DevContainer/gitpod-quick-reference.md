# GitPod Quick Reference Guide

## 🚀 Quick Start Commands

```bash
# Run the migration script
./migrate-to-gitpod.sh

# Start interactive learning
./learn-gitpod.sh

# Open GitPod workspace
./quick-start-gitpod.sh
```

## 📋 Essential GitPod URLs

| Purpose | URL Pattern | Example |
|---------|-------------|---------|
| Open workspace | `https://gitpod.io/#REPO_URL` | `https://gitpod.io/#https://github.com/user/repo` |
| GitHub button | Add to any GitHub repo | `https://github.com/user/repo` |
| GitLab button | Add to any GitLab repo | `https://gitlab.com/user/repo` |
| Bitbucket button | Add to any Bitbucket repo | `https://bitbucket.org/user/repo` |

## ⚙️ .gitpod.yml Configuration

### Basic Structure
```yaml
image: gitpod/workspace-full:latest

ports:
  - port: 3000
    onOpen: open-browser
  - port: 8080
    onOpen: open-browser

tasks:
  - name: Setup
    init: echo "Setting up environment..."
    command: echo "Starting development..."

vscode:
  extensions:
    - ms-vscode.vscode-typescript-next
    - esbenp.prettier-vscode
```

### Advanced Configuration
```yaml
# Custom Docker image
image: your-registry/custom-image:latest

# Environment variables
env:
  - name: NODE_ENV
    value: development
  - name: API_KEY
    value: $API_KEY  # From GitPod secrets

# Git configuration
git:
  config:
    - name: user.name
      value: "Your Name"
    - name: user.email
      value: "your@email.com"

# Prebuild configuration
github:
  prebuilds:
    master: true
    branches: true
    pullRequests: true
```

## 🔧 Cursor IDE Integration

### Method 1: GitPod Extension
1. Install "GitPod" extension in Cursor
2. Command Palette → "GitPod: Open in GitPod"
3. Select repository → Workspace opens in browser

### Method 2: Remote SSH
1. Install "Remote - SSH" extension
2. In GitPod: `gp init-remote-ssh`
3. Copy SSH command to Cursor
4. Connect via Remote-SSH

### Method 3: Direct Browser
1. Open `https://gitpod.io/#your-repo-url`
2. Use built-in VS Code in browser
3. Sync with local Cursor via git

## 🛠️ Common Tasks

### Port Forwarding
```bash
# List open ports
gp ports list

# Open port in browser
gp preview 3000

# Make port public
gp ports visibility 3000:public
```

### Workspace Management
```bash
# Stop workspace
gp stop

# Create snapshot
gp snapshot create

# List snapshots
gp snapshot list

# Resume from snapshot
gp snapshot restore SNAPSHOT_ID
```

### Environment Variables
```bash
# Set environment variable
gp env MY_VAR=value

# List environment variables
gp env

# Remove environment variable
gp env -u MY_VAR
```

## 🐛 Troubleshooting

### Workspace Won't Start
- Check `.gitpod.yml` syntax
- Verify Docker image exists
- Check resource limits
- Review GitPod logs

### Port Not Accessible
- Verify port configuration
- Check if service is running
- Try different port number
- Check firewall settings

### Extensions Not Installing
- Verify extension IDs
- Check marketplace access
- Try manual installation
- Review VS Code logs

### Performance Issues
- Check workspace resources
- Optimize `.gitpod.yml`
- Consider using prebuilds
- Monitor resource usage

## 📚 Learning Resources

### Official Documentation
- [GitPod Docs](https://www.gitpod.io/docs)
- [Configuration Reference](https://www.gitpod.io/docs/config-gitpod-file)
- [VS Code Integration](https://www.gitpod.io/docs/vscode-integration)

### Community
- [GitPod Community](https://community.gitpod.io)
- [GitHub Discussions](https://github.com/gitpod-io/gitpod/discussions)
- [Discord Server](https://discord.gg/gitpod)

### Video Tutorials
- [GitPod YouTube Channel](https://www.youtube.com/c/GitPod)
- [Getting Started Playlist](https://www.youtube.com/playlist?list=PLPjzjqtTfH0F4YVEiuseVa1j9zA6Pv0y1)
- [Advanced Features](https://www.youtube.com/playlist?list=PLPjzjqtTfH0F4YVEiuseVa1j9zA6Pv0y1)

## 💡 Pro Tips

### Development
- Use branches for feature development
- Commit changes frequently
- Use snapshots for important states
- Leverage prebuilds for faster startup

### Team Collaboration
- Share workspace URLs
- Use consistent configurations
- Document setup procedures
- Use environment variables for secrets

### Performance
- Keep `.gitpod.yml` simple
- Use official images when possible
- Enable prebuilds for large projects
- Monitor resource usage

### Security
- Use environment variables for secrets
- Don't commit sensitive data
- Review workspace permissions
- Use private repositories when needed

## 🆚 GitPod vs Alternatives

| Feature | GitPod | Docker Desktop | Codespaces | Replit |
|---------|--------|----------------|------------|--------|
| Setup Time | 10-30s | 2-5min | 30-60s | 5-10s |
| Resource Usage | Cloud | Local | Cloud | Cloud |
| Reliability | High | Medium | High | High |
| Cost | Free tier | Free | Paid | Free tier |
| Offline | No | Yes | No | No |
| Sharing | Easy | Hard | Easy | Easy |
| Custom Images | Yes | Yes | Yes | Limited |

## 🎯 When to Use GitPod

### ✅ Perfect For
- Team development
- Open source projects
- Learning and tutorials
- CI/CD workflows
- Cross-platform development
- Resource-intensive tasks

### ❌ Not Ideal For
- Offline development
- Very large local datasets
- Strict security requirements
- Legacy system integration
- High-frequency local testing

## 🚀 Getting Started Checklist

- [ ] Create GitPod account
- [ ] Connect GitHub/GitLab/Bitbucket
- [ ] Run migration script
- [ ] Test first workspace
- [ ] Install Cursor extension
- [ ] Configure development workflow
- [ ] Share with team
- [ ] Set up prebuilds (optional)
- [ ] Configure environment variables
- [ ] Document team procedures

---

**Need help?** Check the troubleshooting section or visit the [GitPod Community](https://community.gitpod.io)!
