# we start from a 'pylibs-toolkit' image
ARG DOCKER_LIBS_IMAGE
FROM ${DOCKER_LIBS_IMAGE}

# Set the path where the app will be installed
ENV APP_PATH "/app"

# Copy source path
COPY src ${APP_PATH}

# Copy utility scripts
COPY init.sh /usr/local/bin/
COPY start.sh /usr/local/bin/
COPY wait-for-init.sh /usr/local/bin/

# Set the current WorkDIR
WORKDIR ${APP_PATH}

# Update env and system software
RUN \
    # set python3 as default Python interpreter
    update-alternatives --install /usr/bin/python python /usr/bin/python3 10\
    # set proper permissions for utility scripts
    && chmod +x /usr/local/bin/init.sh /usr/local/bin/start.sh /usr/local/bin/wait-for-init.sh \
    # install app requirements
    && pip --no-cache-dir install -r requirements.txt
