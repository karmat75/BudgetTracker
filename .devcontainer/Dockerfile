FROM ubuntu:24.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    sqlite3 \
    libsqlite3-dev \
    ca-certificates \
    gnupg \
    sudo \
    vim \
    lsof \
    && rm -rf /var/lib/apt/lists/*

# Install Python (use whatever version Ubuntu 24.04 provides by default)
RUN apt-get update && apt-get install -y \
    python3 \
    python3-venv \
    python3-dev \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set python3 as default python
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

# Install Node.js 20 LTS
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Upgrade npm to latest version
RUN npm install -g npm@latest

# Create non-root user
RUN useradd -m -s /bin/bash vscode && \
    usermod -aG sudo vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Create Python virtual environment and set ownership
RUN python3 -m venv /opt/venv && \
    chown -R vscode:vscode /opt/venv

# Activate venv and upgrade pip
RUN /opt/venv/bin/pip install --upgrade pip

# Add venv to PATH
ENV PATH="/opt/venv/bin:$PATH"

# Set working directory
WORKDIR /workspace

USER vscode

# Set environment variables
ENV PATH="/home/vscode/.local/bin:${PATH}"
ENV PIP_BREAK_SYSTEM_PACKAGES=1
