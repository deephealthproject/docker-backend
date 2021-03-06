#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# move to the script path
# all paths are assumed to be absolute or relative to this path
cd ${SCRIPT_PATH}

# set target path from arguments
SECRETS_FILE="${1:-${SCRIPT_PATH}/.secrets.json}"

# set settings filename
SETTINGS_FILE=${SETTINGS_FILE:-"settings.conf"}

# load settings
set -a
# shellcheck disable=SC1090
source "${SETTINGS_FILE}"
set +a

set -o errexit
set -o nounset

# shellcheck disable=SC2034 ## used by envsubst
export CELERY_KEY=$(\
docker run -it --rm "${DOCKER_BACKEND_IMAGE}" \
python3 -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())' | tr -d '[:space:]')

# generate secrets from template
envsubst < ${SCRIPT_PATH}/secrets-template.json > "${SECRETS_FILE}"
