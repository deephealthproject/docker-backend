#!/bin/bash

## Notice that we assume /app as current working directory

# Apply all available migrations
python manage.py migrate

# Creating an admin user (non-interactive)
# (~equivalent to the interactive cmd `python manage.py createsuperuser`)
cat <<EOF | python manage.py shell
from django.contrib.auth import get_user_model
User = get_user_model()  # get the currently active user model,
User.objects.filter(username='${ADMIN_USER}').exists() or \
    User.objects.create_superuser('${ADMIN_USER}', '${ADMIN_EMAIL}', '${ADMIN_PASSWORD}')
EOF

# Initialize Django fixtures for the DB init
# This will also download ONNX weights of the models
python scripts/init_fixtures.py

# Load fixtures into the DB (default entries)
python manage.py loaddata \
                    tasks.json \
                    property.json \
                    allowedproperty.json \
                    dataset.json \
                    model.json \
                    modelweights.json # auth.json
