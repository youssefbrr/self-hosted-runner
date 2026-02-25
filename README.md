# Self-Hosted Runner Dockerization

Welcome to the GitHub Self-Hosted Runner Dockerization repository. This project provides a Dockerized solution for setting up a self-hosted GitHub Actions runner.

## Features

- **Docker Compose Setup**: Easily deploy self-hosted runners using Docker Compose.
- **Customizable**: Use the provided Docker image or build your own using the Dockerfile.
- **Scalable**: Deploy multiple runner replicas with resource constraints.
- **Cross-Platform**: Support for Linux, macOS, and Windows environments.

## Repository Contents

- `LICENSE`: The license file for this project.
- `README.md`: The documentation file you are currently reading.
- `docker-compose.yml`: The Docker Compose file to deploy the self-hosted runner on Linux.
- `docker-compose.mac.yml`: The Docker Compose file to deploy the self-hosted runner on macOS.
- `docker-compose.windows.yml`: The Docker Compose file to deploy the self-hosted runner on Windows.
- `Docker Image/`: A directory containing the Dockerfiles and start scripts for building the runner images.

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

2. Edit the `docker-compose.yml` file to specify your repository, registration token, and runner name.

3. Deploy the self-hosted runner:
   ```sh
   docker-compose up -d
   ```

### Using Docker Compose on macOS

1. Clone the repository:

   ```sh
   git clone https://github.com/youssefbrr/self-hosted-runner.git
   cd self-hosted-runner
   ```

2. Edit the `docker-compose.mac.yml` file to specify your repository, registration token, and runner name.

3. Deploy the self-hosted runner:
   ```sh
   docker-compose -f docker-compose.mac.yml up -d
   ```

### Using Docker Compose on Windows

1. Prerequisites:

   - Install Docker Desktop for Windows
   - Enable WSL 2 (Windows Subsystem for Linux)
   - Install Ubuntu 20.04 from the Microsoft Store or enable it through PowerShell

2. Clone the repository:

   ```sh
   git clone https://github.com/youssefbrr/self-hosted-runner.git
   cd self-hosted-runner
   ```

3. Edit the `docker-compose.windows.yml` file to specify your repository, registration token, and runner name.

4. Deploy the self-hosted runner:
   ```sh
   docker-compose -f docker-compose.windows.yml up -d
   ```

### Building Your Own Docker Image on Linux

1. Clone the repository:

   ```sh
   git clone https://github.com/youssefbrr/self-hosted-runner.git
   cd self-hosted-runner
   ```

2. Build the Docker image:

   ```sh
   cd Docker Image
   docker build -t custom-github-runner:latest ./
   ```

3. Edit the `docker-compose.yml` file to use your custom image.

4. Deploy the self-hosted runner:
   ```sh
   docker-compose up -d
   ```

### Building Your Own Docker Image on macOS

1. Clone the repository:

   ```sh
   git clone https://github.com/youssefbrr/self-hosted-runner.git
   cd self-hosted-runner
   ```

2. Build the Docker image:

   ```sh
   cd Docker Image
   docker build -t custom-github-runner-mac:latest -f Dockerfile.mac ./
   ```

3. Edit the `docker-compose.mac.yml` file to use your custom image.

4. Deploy the self-hosted runner:
   ```sh
   docker-compose -f docker-compose.mac.yml up -d
   ```

### Building Your Own Docker Image on Windows

1. Clone the repository:

   ```sh
   git clone https://github.com/youssefbrr/self-hosted-runner.git
   cd self-hosted-runner
   ```

2. Build the Docker image:

   ```sh
   cd Docker Image
   docker build -t custom-github-runner-windows:latest -f Dockerfile.windows ./
   ```

3. Edit the `docker-compose.windows.yml` file to use your custom image.

4. Deploy the self-hosted runner:
   ```sh
   docker-compose -f docker-compose.windows.yml up -d
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

## Notes for Windows Users

For Windows, keep in mind:

1. You need to have Docker Desktop for Windows installed and running.
2. WSL 2 must be enabled and properly configured.
3. The Ubuntu 20.04 distribution should be installed through WSL.
4. Performance may vary depending on your system's virtualization settings.
5. Make sure your Windows system meets the minimum requirements for running Docker Desktop and WSL 2.
