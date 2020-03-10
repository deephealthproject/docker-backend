#!/bin/bash

# set target path from arguments
SECRETS_FILE="${1:-.secrets.json}"

# set settings filename
SETTINGS_FILE=${SETTINGS_FILE:-"settings.conf"}

# set the current user
export UID
export GID=$(id -g)

# load settings
set -a
# shellcheck disable=SC1090
source "${SETTINGS_FILE}"
set +a

set -o errexit
set -o nounset

# set backend local path
if [[ -n "${BACKEND_LOCAL_PATH:-}" ]]; then
  export BACKEND_VOLUME="- ${BACKEND_LOCAL_PATH}:/app"
fi

# generate docker-compose file
envsubst < docker-compose.template.yml > docker-compose.yml

# clone sources
if [[ ! -d "docker/src" ]]; then
  if [[ -z "${BACKEND_LOCAL_PATH:-}" ]]; then
    #git clone --depth=1 https://github.com/deephealthproject/backend.git docker/src
    git clone --depth=1 git@github.com:deephealthproject/backend.git docker/src
  else
    cp -al "${BACKEND_LOCAL_PATH}" docker/src
  fi
fi

# build images
docker-compose build --build-arg DOCKER_LIBS_IMAGE="${DOCKER_LIBS_IMAGE:-}"

# clean up source
#rm -rf docker/src

if [[ ! -f "${SECRETS_FILE}" ]]; then
  ./create-secrets.sh "${SECRETS_FILE}"
fi

