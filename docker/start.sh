#!/bin/bash

command="${1}"

if [[ ! "${command}" =~ ^(backend|celery|bash)$ ]]; then
    echo -e "\nERROR: Command \"${command} \" not supported !"
    echo -e "       Supported commands: backend | ipython| bash \n"
    exit 99
fi

if [[ "${command}" == "backend" ]]; then
  source "${APP_PATH}/settings.conf"
  init.sh
  python manage.py runserver "0.0.0.0:${BACKEND_PORT}"
elif [[ "${command}" == "celery" ]]; then
  python manage.py celery
else
  /bin/bash "$@"
fi
