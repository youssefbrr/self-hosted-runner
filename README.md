# Self-Hosted Runner Dockerization

Welcome to the GitHub Self-Hosted Runner Dockerization repository. This project provides a Dockerized solution for setting up a self-hosted GitHub Actions runner.

## Features

- **Docker Compose Setup**: Easily deploy self-hosted runners using Docker Compose.
- **Customizable**: Use the provided Docker image or build your own using the Dockerfile.
- **Scalable**: Deploy multiple runner replicas with resource constraints.
- **Cross-Platform**: Support for Linux and macOS (ARM64) environments.

## Repository Contents

- `LICENSE`: The license file for this project.
- `README.md`: The documentation file you are currently reading.
- `docker/linux/`: Directory containing Linux-specific Docker files:
  - `Dockerfile`: Dockerfile for building the Linux runner image.
  - `docker-compose.yml`: Docker Compose file to deploy the self-hosted runner on Linux.
  - `start.sh`: Start script for the Linux runner.
- `docker/mac/`: Directory containing macOS-specific Docker files:
  - `Dockerfile`: Dockerfile for building the macOS (ARM64) runner image.
  - `docker-compose.yml`: Docker Compose file to deploy the self-hosted runner on macOS.
  - `start.sh`: Start script for the macOS runner.

## Getting Started

### Prerequisites

- Docker
- Docker Compose

### Using Docker Compose on Linux

1. Clone the repository:

    ```sh
    git clone https://github.com/youssefbrr/self-hosted-runner.git
    cd self-hosted-runner
    ```

2. Copy the example environment file and fill in your values:

    ```sh
    cp .env.example .env
    # Edit .env to add your REPO, REG_TOKEN, and NAME values
    ```

3. Deploy the self-hosted runner:

    ```sh
    docker-compose -f docker/linux/docker-compose.yml up -d
    ```

2. Edit the `docker/linux/docker-compose.yml` file to specify your repository, registration token, and runner name.

3. Deploy the self-hosted runner:
   ```sh
   docker-compose -f docker/linux/docker-compose.yml up -d
   ```

### Using Docker Compose on macOS

1. Clone the repository:

   ```sh
   git clone https://github.com/youssefbrr/self-hosted-runner.git
   cd self-hosted-runner
   ```

2. Edit the `docker/mac/docker-compose.yml` file to specify your repository, registration token, and runner name.

3. Deploy the self-hosted runner:
   ```sh
   docker-compose -f docker/mac/docker-compose.yml up -d
   ```

### Building Your Own Docker Image on Linux

1. Clone the repository:

   ```sh
   git clone https://github.com/youssefbrr/self-hosted-runner.git
   cd self-hosted-runner
   ```

2. Build the Docker image:

   ```sh
   cd docker/linux
   docker build -t custom-github-runner:latest ./
   ```

3. Edit the `docker/linux/docker-compose.yml` file to use your custom image.

4. Deploy the self-hosted runner:
   ```sh
   docker-compose -f docker/linux/docker-compose.yml up -d
   ```

### Building Your Own Docker Image on macOS

1. Clone the repository:

   ```sh
   git clone https://github.com/youssefbrr/self-hosted-runner.git
   cd self-hosted-runner
   ```

2. Build the Docker image:

   ```sh
   cd docker/mac
   docker build -t custom-github-runner-mac:latest ./
   ```

3. Edit the `docker/mac/docker-compose.yml` file to use your custom image.

4. Deploy the self-hosted runner:
   ```sh
   docker-compose -f docker/mac/docker-compose.yml up -d
   ```

## Configuration

### Environment Variables

- `REPO`: The GitHub repository to register the runner to (format: `<owner>/<repo>`). It can also be set to an organization instead of a repository (format: `<owner>`).
- `REG_TOKEN`: The registration token for the self-hosted runner from the GitHub repository settings.
- `NAME`: The name of the self-hosted runner.

## Notes for macOS Users

For macOS, keep in mind:

1. You need to have Docker Desktop for Mac installed and running.
2. The macOS runner uses different base images and paths compared to the Linux version.
3. Performance may differ from the Linux version due to the virtualization layer.

## Healthchecks

Both Linux and macOS services include healthchecks that verify the runner process is running using `pgrep -f run.sh`. Health checks begin after a 40s start period and run every 30s.
