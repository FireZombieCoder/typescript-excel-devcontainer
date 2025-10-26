FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# Install additional system dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        build-essential \
        python3 \
        python3-pip \
        python3-venv \
        unzip \
        zip \
        jq \
        vim \
        nano \
        htop \
        tree \
        ca-certificates \
        gnupg \
        lsb-release \
        software-properties-common \
        apt-transport-https \
        wget \
        curl \
        git \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20 (if not already installed)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Verify Node.js installation
RUN node --version && npm --version

# Install global Node.js tools for Office development
RUN npm install -g \
    typescript \
    ts-node \
    @types/node \
    eslint \
    prettier \
    webpack \
    webpack-cli \
    rollup \
    jest \
    @playwright/test \
    yo \
    generator-office

# Install Office.js types and tools globally
RUN npm install -g \
    @types/office-js \
    @types/office-runtime

# Set up Git configuration
RUN git config --global init.defaultBranch main && \
    git config --global pull.rebase false && \
    git config --global user.name "FireZombieCoder" && \
    git config --global user.email "firezombify@gmail.com"

# Create workspace structure
RUN mkdir -p /workspace/{projects,templates,examples,docs,scripts}

# Set proper permissions
RUN chown -R vscode:vscode /workspace

# Expose ports
EXPOSE 3000 8080 9229
