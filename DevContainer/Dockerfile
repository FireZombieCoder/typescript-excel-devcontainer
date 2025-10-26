# Stage 1 – Base
FROM ubuntu:22.04 as base

# Common system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        curl \
        ca-certificates \
        build-essential \
        # Add more packages here
    && rm -rf /var/lib/apt/lists/*

# Optional: Add a non‑root user
ARG USERNAME=dev
ARG UID=1000
ARG GID=1000
RUN groupadd --gid ${GID} ${USERNAME} \
    && useradd --uid ${UID} --gid ${GID} --create-home --shell /bin/bash ${USERNAME}

# Switch to user
USER ${USERNAME}
WORKDIR /workspaces

# Expose a default shell
CMD ["bash"]
