#!/bin/bash

set +x

MyDir=$(cd `dirname $0` && pwd)
helm repo update
helm install --name deephealth-backend -f "${MyDir}/values.yaml" --version 0.1.2 "${@}" dhealth/deephealth-backend 2>&1 | tee install.log
