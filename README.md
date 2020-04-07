![GitHub release (latest by date)](https://img.shields.io/github/v/release/deephealthproject/docker-backend)![GitHub](https://img.shields.io/github/license/deephealthproject/docker-backend)


# docker-backend

Containerization of the DeepHealth back end (see [https://github.com/deephealthproject/backend]()).

Keep on reading to see how to [deploy on Kubernetes](#deploy-on-kubernetes) or
how to run it or develop [using docker-compose](#develop-with-dockerCompose).


## Deploy on Kubernetes

### Requirements

*  Kubernetes volume provisioner with support for `ReadWriteMany` *access mode* (e.g., **Ceph**, **NFS**, etc.)
*  **Helm 2**

### Installation

Clone the [`docker-backend`](https://github.com/deephealthproject/docker-backend) repository:

```
git clone git@github.com:deephealthproject/docker-backend.git
```

Collect `helm` dependencies by typing:

```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add crs4 https://crs4.github.io/helm-charts/
helm repo add deephealth https://deephealthproject.github.io/helm-charts/
helm dependency build k8s/deephealth-backend
```

<!--
Add the `helm-charts` repository:

```
helm add repo crs4 https://crs4.github.io/helm-charts/
```

Download the `values.yaml` file to customise your deployment:

```
curl https://raw.githubusercontent.com/deephealthproject/docker-backend/develop/k8s/deephealth-backend/values.yaml -o values.yaml
```
-->

Edit the ´k8s/values.yaml´ template to configure your deployment. In particular, you should set the storage classes to handle the persistence volumes of your deployment:

```
...
# persistence class used by services
storageClass: &servicesStorageClass default

# persistence classes (ReadWriteMany accessMode required)
datasetsStorageClass: *servicesStorageClass
trainingStorageClass: *servicesStorageClass
inferenceStorageClass: *servicesStorageClass
...
```

Deploy on Kubernetes through `helm`:

```
helm install --name deephealth-backend k8s/deephealth-backend -f k8s/values.yaml
```

<!--
```
helm install --name deephealth-backend crs4/deephealth-backend -f values.yaml
```
-->

Take a look at the deployment notes to know how to access services  (`helm status deephealth-backend`).


#### Access via Ingress

If available an Ingress Controller on your Kubernetes cluster, you can access the back-end endpoint by setting the upper level `ingress` property on the `values.yaml` file:

```
ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: nginx
    # kubernetes.io/tls-acme: "true"
  hosts:
      # Replace host with your
      # ingress controller hostname or IP
    - host: backend.172.30.20.10.nip.io
```

### Helm chart parameters

|           Parameter               |                    Description                   |              Default        |
|-----------------------------------|--------------------------------------------------|-----------------------------|
| `storageClass`                    | Storage class used by services                   |  `nil`                      |
| `datasetsStorageClass`            | Storage class used for datasets                  |  `*storageClass`            |
| `trainingStorageClass`            | Storage class used for training datasets         |  `*datasetsStorageClass`    |
| `inferenceStorageClass`           | Storage class used for inference datasets        |  `*datasetsStorageClass`    |
| `datasetsStorageSize`             | Size requested for dataset PVC                   | |
| `trainingStorageSize`             | Size requested for training dataset PVC          | |
| `inferenceStorageSize`            | Size requested for inference dataset PVC         | |
| `ingress.enabled`                 | | |
| `djangoSecret`                    | | |
| `dataPaths.datasets`              | | `/data/datasets` |
| `dataPaths.training`              | | `/data/training` |
| `dataPaths.inference`             | | `/data/inference` |

TODO:  complete table

## Develop with Docker(Compose)

`docker-backend` allows to easily setup a development environment.

#### Requirements

*  **Docker** (>= 19.03.5)
*  **DockerCompose** (>=1.25.4)



### Installation

1. Edit the file  `settings.conf` to customize your setup (e.g., services credentials and ports).

   Some relevant settings are:


     * `DOCKER_LIBS_IMAGE`, i.e., the `docker-libs` image to use (see [deephealthproject](https://github.com/deephealthproject)/**[docker-libs](https://github.com/deephealthproject/docker-libs)**), important to ensure the support of specific versions of the DeepHealth libraries;


   * `DOCKER_RUNTIME`, i.e., the default Docker runtime `runc` or `nvidia` to leverage GPUs;
   * `BACKEND_LOCAL_PATH`, to mount and directly develop with your local copy of the [deephealthproject](https://github.com/deephealthproject)/**[backend](https://github.com/deephealthproject/backend)** on Docker

2. Type `./setup.sh` to generate configuration files and generate the Docker images.

### Usage

Type ``` docker-compose  up -d ``` to start all the services and after a while you should have the Back-end API up and running at http://<YOUR_HOST_IP>:<BACKEND_PORT> (http://localhost:8000 by default).

Use `docker-compose logs [service]` to see the logs of the running services.

Type `docker-compose down` to stop and remove all the containers in use.


## License

This software is distributed under the [MIT License](https://opensource.org/licenses/MIT), see [LICENSE](./LICENSE) for more information.
