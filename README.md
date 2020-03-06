![GitHub release (latest by date)](https://img.shields.io/github/v/release/deephealthproject/docker-backend)![GitHub](https://img.shields.io/github/license/deephealthproject/docker-backend)


# docker-backend

Docker resources for the DeepHealth Back-end (see https://github.com/deephealthproject/backend).



## Develop with Docker(Compose)

`docker-backend` allows to easily setup a development environment.



#### Requirements

*  **Docker** (>= 19.03.5)
*  **DockerCompose** (>=1.25.4)



#### Installation

1. Edit the file  `settings.conf` to customize your setup (e.g., services credentials and ports).

   Some relevant settings are:


     * `DOCKER_LIBS_IMAGE`, i.e., the `docker-libs` image to use (see [deephealthproject](https://github.com/deephealthproject)/**[docker-libs](https://github.com/deephealthproject/docker-libs)**), important to ensure the support of specific versions of the DeepHealth libraries;


   * `DOCKER_RUNTIME`, i.e., the default Docker runtime `runc` or `nvidia` to leverage GPUs;
   * `BACKEND_LOCAL_PATH`, to mount and directly develop with your local copy of the [deephealthproject](https://github.com/deephealthproject)/**[backend](https://github.com/deephealthproject/backend)** on Docker

2. Type `./setup.sh` to generate configuration files and generate the Docker images.

##### 

#### Usage

Type ``` docker-compose  up -d ``` to start all the services and after a while you should have the Back-end API up and running at http://<YOUR_HOST_IP>:<BACKEND_PORT> (http://localhost:8000 by default).

Use `docker-compose logs [service]` to see the logs of the running services.

Type `docker-compose down` to stop and remove all the containers in use.

