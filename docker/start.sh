#!/bin/bash

command="${1}"

if [[ ! "${command}" =~ ^(backend|celery|bash)$ ]]; then
    echo -e "\nERROR: Command \"${command} \" not supported !"
    echo -e "       Supported commands: backend | ipython| bash \n"
    exit 99
fi

wait-for-postgres.sh

if [[ "${command}" == "backend" ]]; then
  python manage.py runserver "0.0.0.0:${BACKEND_PORT}"
elif [[ "${command}" == "celery" ]]; then
  wait-for-it.sh -h "${RABBITMQ_HOST}" -p "${RABBITMQ_PORT}"
  python manage.py celery
else
  /bin/bash "$@"
fi
