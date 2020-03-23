#!/bin/bash

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

# Create a SECRET_KEY
export SECRET_KEY=$(\
docker run -it --rm "${DOCKER_BACKEND_IMAGE}" \
python3 -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())' | tr -d '[:space:]')

# generate config file from settings
envsubst < config.template > .config

# generate a config file from settings
envsubst < docker-compose.template.yml > docker-compose.yml

# set backend local path
if [[ -n "${BACKEND_LOCAL_PATH:-}" ]]; then
  export BACKEND_VOLUME="- ${BACKEND_LOCAL_PATH}:/app"
fi

# clone sources
if [[ ! -d "docker/src" ]] || [[ ! -L "docker/src" ]]; then
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
