# Self-Hosted Runner Dockerization

Welcome to the GitHub Self-Hosted Runner Dockerization repository. This project provides a Dockerized solution for setting up a self-hosted GitHub Actions runner.

## Features

- **Docker Compose Setup**: Easily deploy self-hosted runners using Docker Compose.
- **Customizable**: Use the provided Docker image or build your own using the Dockerfile.
- **Scalable**: Deploy multiple runner replicas with resource constraints.

## Repository Contents

- `LICENSE`: The license file for this project.
- `README.md`: The documentation file you are currently reading.
- `docker-compose.yml`: The Docker Compose file to deploy the self-hosted runner.
- `Docker Image/`: A directory containing the Dockerfile and `start.sh` script for building the runner image.

## Getting Started

### Prerequisites

- Docker
- Docker Compose

### Using Docker Compose

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

### Building Your Own Docker Image

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

## Configuration

### Environment Variables

- `REPO`: The GitHub repository to register the runner to (format: `<owner>/<repo>`).
- `REG_TOKEN`: The registration token for the self-hosted runner from the GitHub repository settings.
- `NAME`: The name of the self-hosted runner.
