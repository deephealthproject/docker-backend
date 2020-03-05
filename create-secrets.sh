#!/bin/bash

# set target path from arguments
SECRETS_FILE="${1:-.secrets.json}"

# set settings filename
SETTINGS_FILE=${SETTINGS_FILE:-"settings.conf"}

# load settings
set -a
# shellcheck disable=SC1090
source "${SETTINGS_FILE}"
set +a

# shellcheck disable=SC2034 ## used by envsubst
export CELERY_KEY=$(\
docker run -it --rm "${DOCKER_BACKEND_IMAGE}" \
python3 -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())' | tr -d '[:space:]')

# generate secrets from template
envsubst < secrets-template.json > "${SECRETS_FILE}"