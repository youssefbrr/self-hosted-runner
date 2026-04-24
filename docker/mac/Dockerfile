FROM --platform=linux/arm64 ubuntu:latest

ARG RUNNER_VERSION="2.317.0"

# Add a user for the runner
RUN useradd -m -s /bin/bash runner

# Install necessary packages including .NET Core dependencies
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    python3 \
    sudo \
    libicu-dev \
    libkrb5-3 \
    zlib1g \
    iputils-ping \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Set up the runner user
RUN echo "runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

WORKDIR /home/runner

# Set up the actions runner for ARM64
RUN mkdir -p /home/runner/actions-runner && cd /home/runner/actions-runner \
    && curl -o actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz \
    && tar xzf actions-runner-linux-arm64-${RUNNER_VERSION}.tar.gz

# Install dependencies
RUN cd /home/runner/actions-runner \
    && ./bin/installdependencies.sh

# Copy the start script and make it executable
COPY start.sh /home/runner/start.sh
RUN chown runner:runner /home/runner/start.sh && chmod +x /home/runner/start.sh

# Switch to runner user
USER runner

# Define the entrypoint
ENTRYPOINT ["/home/runner/start.sh"] 