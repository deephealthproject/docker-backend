# we start from a 'pylibs-toolkit' image
ARG DOCKER_LIBS_IMAGE
FROM ${DOCKER_LIBS_IMAGE}

# Set image user
ARG UID=1000
ARG GID=1000
ARG USERNAME=backend

# Set defaults
ARG BACKEND_PORT=8000
ENV BACKEND_PORT ${BACKEND_PORT}

# Set the path where the app will be installed
ENV APP_PATH "/app"

# Set data paths
ARG DATA_DIR="/data"
ENV DATA_DIR=${DATA_DIR}

# Locale settings
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

# Copy source path
COPY src ${APP_PATH}

# Copy utility scripts
COPY init.sh /usr/local/bin/
COPY start.sh /usr/local/bin/
COPY wait-for-it.sh /usr/local/bin/
COPY wait-for-postgres.sh /usr/local/bin/

# Set the current WorkDIR
WORKDIR ${APP_PATH}

# Update env and system software
RUN \
    apt-get update -y -q \
    && apt-get install -y --no-install-recommends libpq-dev postgresql-client graphviz libgraphviz-dev \
    && apt-get clean \
    # set python3 as default Python interpreter
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 10\
    # set proper permissions for utility scripts
    && chmod +x /usr/local/bin/init.sh \
                /usr/local/bin/start.sh \
                /usr/local/bin/wait-for-it.sh \
                /usr/local/bin/wait-for-postgres.sh \
    # install app requirements
    && pip --no-cache-dir install -r requirements.txt \
    && pip --no-cache-dir install click==7.1.2 \
    # create the user
    && groupadd ${USERNAME} -g ${GID} || true \
    && useradd -m -u ${UID} -g ${GID} ${USERNAME} \
    && chown -R ${USERNAME} ${APP_PATH} \
    && mkdir -p ${DATA_DIR} \
    && chown -R ${USERNAME} ${DATA_DIR}

# Set the default user
USER ${USERNAME}

# Default command
CMD start.sh backend
