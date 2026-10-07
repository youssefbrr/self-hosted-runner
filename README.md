# Self-Hosted GitHub Actions Runner

Dockerized GitHub Actions self-hosted runners for Linux (x64) and macOS (ARM64). Deploy in minutes, scale with replicas, deregister cleanly on shutdown.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![GitHub Stars](https://img.shields.io/github/stars/youssefbrr/self-hosted-runner?style=social)](https://github.com/youssefbrr/self-hosted-runner/stargazers)

---

## Quick Start

```sh
git clone https://github.com/youssefbrr/self-hosted-runner.git
cd self-hosted-runner
cp .env.example .env        # fill in REPO, REG_TOKEN, NAME
```

**Linux (x64)**
```sh
docker-compose -f docker/linux/docker-compose.yml up -d
```

**macOS / ARM64**
```sh
docker-compose -f docker/mac/docker-compose.yml up -d
```

> **REG_TOKEN expires after 1 hour.** Generate a fresh one from
> GitHub → Settings → Actions → Runners → "New self-hosted runner" before each deploy.

---

## Pre-built Image vs Local Build

Both variants support pre-built images from GHCR. By default, `docker-compose up` pulls the pre-built image — no build step required.

| Variant | Image | Tag |
|---------|-------|-----|
| **Linux (x64)** | `ghcr.io/youssefbrr/self-hosted-runner` | `latest` |
| **macOS / ARM64** | `ghcr.io/youssefbrr/self-hosted-runner` | `latest-arm64` |

| Mode | How | When to use |
|------|-----|-------------|
| **Pre-built** (default) | Just run `docker-compose up` | Quick setup, no customization needed |
| **Local build** | Uncomment `build: .` in the compose file | Custom Dockerfile changes, runner version overrides |

---

## Features

- **Zero-config start** — set 3 env vars and run
- **Persistent runner state** — runner registration is reused across restarts
- **Scalable** — Linux defaults to 2 replicas; tune with `deploy.replicas`
- **Ephemeral mode** — run once and self-destruct (`EPHEMERAL=true`)
- **Docker-in-Docker** — macOS image mounts the Docker socket for nested builds
- **GitHub CLI** — `gh` pre-installed from official repos on both variants
- **Docker CLI** — official Docker CE CLI with buildx and compose plugins
- **Healthchecks** — built-in `pgrep run.sh` health monitoring on both variants

---

## Architecture

```
docker/
├── linux/          Ubuntu 24.04, x64, runner v2.331.0
│   ├── Dockerfile        user: docker, workdir: /home/docker/actions-runner
│   ├── docker-compose.yml  2 replicas · 0.5 CPU · 512M each
│   └── start.sh
└── mac/            Ubuntu 24.04, ARM64, runner v2.331.0
    ├── Dockerfile        user: runner, workdir: /home/runner/actions-runner
    ├── docker-compose.yml  1 replica · 1 CPU · 1G · Docker socket mounted
    └── start.sh
```

Both `start.sh` scripts: configure via `config.sh` → trap SIGINT/SIGTERM for deregistration → exec `run.sh`.

---

## Configuration

Copy `.env.example` to `.env` and set your values. The `.env` file is gitignored.

### Required

| Variable | Description |
|----------|-------------|
| `REPO` | `owner/repo` for repo-level or `owner` for org-level runners |
| `REG_TOKEN` | Registration token from GitHub Settings (expires in 1 hour) |
| `NAME` | Display name shown in GitHub Actions UI |

### Optional

| Variable | Default | Description |
|----------|---------|-------------|
| `LABELS` | _(none)_ | Comma-separated labels, e.g. `self-hosted,linux,x64,gpu` |
| `RUNNER_GROUP` | _(default)_ | Runner group name — org/enterprise only |
| `WORK_DIR` | `_work` | Workspace directory inside the container |
| `EPHEMERAL` | `false` | `true` → deregister after one job |
| `DISABLE_AUTO_UPDATE` | `false` | `true` → prevent runner self-updates |
| `REMOVE_RUNNER_ON_EXIT` | `false` | `true` → deregister runner when container stops (requires fresh `REG_TOKEN`) |

### Override Runner Version

```sh
docker build --build-arg RUNNER_VERSION=2.332.0 -t custom-github-runner:latest ./docker/linux
```

---

## Registering to an Organization

Set `REPO` to just the org name:

```env
REPO=my-org
```

The runner will register at org level and be available to all repositories in that org.

---

## Workflows Example

Reference your runner in any workflow file:

```yaml
jobs:
  build:
    runs-on: [self-hosted, linux]
    steps:
      - uses: actions/checkout@v4
      - run: echo "Running on self-hosted runner"
```

Use your custom labels to target specific runners:

```yaml
runs-on: [self-hosted, linux, gpu]
```

---

## Scaling

Adjust replicas in `docker-compose.yml` under `deploy.replicas`. GitHub will distribute jobs across all registered runners automatically.

```yaml
deploy:
  replicas: 4       # spin up 4 concurrent runners
  resources:
    limits:
      cpus: '0.5'
      memory: 512M
```

---

## Persistence Across Restarts

Both compose files mount a named volume to persist the runner home directory:

- Linux: `/home/docker/actions-runner`
- ARM64: `/home/runner/actions-runner`

This keeps the runner registration/configuration after container restarts or recreates, so you don't need to re-register with a new token every time.

If you want the old behavior (always deregister on shutdown), set:

```env
REMOVE_RUNNER_ON_EXIT=true
```

---

## Publishing Images

GitHub Actions workflows automatically build and publish both images to GHCR on version tag pushes (`v*`).

```sh
git tag v1.0.0
git push origin v1.0.0
```

| Image | Tag | Platform |
|-------|-----|----------|
| `ghcr.io/<owner>/self-hosted-runner` | `latest` / `v1.0.0` | linux/amd64 |
| `ghcr.io/<owner>/self-hosted-runner` | `latest-arm64` / `v1.0.0-arm64` | linux/arm64 |

---

## Troubleshooting

**Runner doesn't appear in GitHub Settings**
- Check `REG_TOKEN` — it expires after 1 hour. Generate a new one.
- Verify `REPO` format: `owner/repo` (no leading slash, no trailing slash).

**Logs**
```sh
docker-compose -f docker/linux/docker-compose.yml logs -f
```

**Health status**
```sh
docker-compose -f docker/linux/docker-compose.yml ps
```

**Runner stuck / won't deregister**
```sh
docker-compose -f docker/linux/docker-compose.yml down
```
If you want automatic deregistration when containers stop, set `REMOVE_RUNNER_ON_EXIT=true` and use a fresh `REG_TOKEN`.

---

## Security

See [SECURITY.md](SECURITY.md) for the vulnerability reporting policy.

Key practices in this project:
- Runners execute as non-root users (`docker` on Linux, `runner` on ARM64)
- Secrets live in `.env` (gitignored) — never hardcoded in compose files
- `REG_TOKEN` is used only at registration time; not stored after config

---

## Contributing

Contributions welcome. Please:

1. Fork the repo and create a branch from `main`
2. Keep changes scoped — one feature or fix per PR
3. Test your change by actually spinning up the container
4. Open a pull request with a clear description of what and why

For bugs or feature requests, [open an issue](https://github.com/youssefbrr/self-hosted-runner/issues).

---

## License

[MIT](LICENSE) — use freely, attribution appreciated.
