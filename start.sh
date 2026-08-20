#!/bin/bash

: "${REPO:?REPO env var required}"
: "${REG_TOKEN:?REG_TOKEN env var required}"
: "${NAME:?NAME env var required}"

if [ -S /var/run/docker.sock ]; then
    DOCKER_GID=$(stat -c '%g' /var/run/docker.sock)
    sudo groupmod -g "$DOCKER_GID" docker 2>/dev/null || true
fi

cd /home/docker/actions-runner || exit

CONFIG_ARGS="--url https://github.com/${REPO} --token ${REG_TOKEN} --name ${NAME}"

[ -n "${LABELS}" ]       && CONFIG_ARGS="${CONFIG_ARGS} --labels ${LABELS}"
[ -n "${RUNNER_GROUP}" ] && CONFIG_ARGS="${CONFIG_ARGS} --runnergroup ${RUNNER_GROUP}"
[ -n "${WORK_DIR}" ]     && CONFIG_ARGS="${CONFIG_ARGS} --work ${WORK_DIR}"
[ "${EPHEMERAL}" = "true" ]            && CONFIG_ARGS="${CONFIG_ARGS} --ephemeral"
[ "${DISABLE_AUTO_UPDATE}" = "true" ]  && CONFIG_ARGS="${CONFIG_ARGS} --disableupdate"

./config.sh ${CONFIG_ARGS}

cleanup() {
  echo "Removing runner..."
  ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
