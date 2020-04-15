#!/bin/bash

## Notice that we assume /app as current working directory

# Apply all available migrations
python3 manage.py migrate

# Create the user if doesn't exist
cat <<EOF | python manage.py shell
from django.contrib.auth import get_user_model
User = get_user_model()  # get the currently active user model,
User.objects.filter(username='${ADMIN_USER}').exists() or \
    User.objects.create_superuser('${ADMIN_USER}', '${ADMIN_EMAIL}', '${ADMIN_PASSWORD}')
EOF
