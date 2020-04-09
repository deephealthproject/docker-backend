![GitHub release (latest by date)](https://img.shields.io/github/v/release/deephealthproject/docker-backend)![GitHub](https://img.shields.io/github/license/deephealthproject/docker-backend)


# docker-backend

Containerization of the DeepHealth back end (see [https://github.com/deephealthproject/backend]()).

Keep on reading to see how to [deploy on Kubernetes](#deploy-on-kubernetes) or how to run it or develop [using docker-compose](#develop-with-dockerCompose).




## Deploy on Kubernetes

### Requirements

*  Kubernetes volume provisioner with support for `ReadWriteMany` *access mode* (e.g., **Ceph**, **NFS**, etc.)
*  **Helm 2**



### Installation

1. Add the `helm-charts` repository:

```bash
helm add repo dhealth https://deephealthproject.github.io/helm-charts/
```

2. Download the `values.yaml` template:

```bash
curl https://raw.githubusercontent.com/deephealthproject/docker-backend/develop/k8s/deephealth-backend/values.yaml -o values.yaml
```

3. Edit the `values.yaml` to configure your deployment ([here](#helm-chart-parameters) the available parameters) 
4. To install the chart with the release name `deephealth-backend` :

```bash
helm install --name deephealth-backend dhealth/deephealth-backend -f values.yaml
```

Take a look at the deployment notes to know how to access services  (`helm status deephealth-backend`).



#### Installation from sources

1. Clone the [`docker-backend`](https://github.com/deephealthproject/docker-backend) repository:

```
git clone git@github.com:deephealthproject/docker-backend.git
```

2. Collect `helm` dependencies by typing:

```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add crs4 https://crs4.github.io/helm-charts/
helm repo add deephealth https://deephealthproject.github.io/helm-charts/
helm dependency build k8s/deephealth-backend
```

3. Edit the ´k8s/values.yaml´ template to configure your deployment ([here](#helm-chart-parameters) the available parameters) 

4. Deploy on Kubernetes through `helm`:

```
helm install --name deephealth-backend k8s/deephealth-backend -f k8s/values.yaml
```

Take a look at the deployment notes to know how to access services  (`helm status deephealth-backend`).



### Access via Ingress

If an Ingress Controller is available on your Kubernetes cluster, you can access the back-end endpoint by setting the upper level `ingress` property on the `values.yaml` file.  Here is an example:

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



### Parameters

The following tables lists the main configurable parameters of the `deephealth-backend` chart and their default values. 

|           Parameter                           |                    Description                                                                |            Default                     |
|-----------------------------------------------|-----------------------------------------------------------------------------------------------|----------------------------------------|
| `global.debug`                                | Enable/disable debug mode                                                                     |  `False`                               |
| `global.storageClass`                         | Global storage class for dynamic provisioning                                                 |  `nil` (i.e., the default sc in your cluster) |
| `global.imagePullPolicy`                      | Global image pull policy                                                                      |  `Always`                              |
| `persistence.datasets.storageClass`           | Storage class used for datasets (requires support for `ReadWriteMany` access mode)            |  `*globalStorageClass`                 |
| `persistence.datasets.path`                   | Path to mount the datasets volume at                                                          |  `/data/datasets`                      |
| `persistence.datasets.size`                   | Size of the datasets volume                                                                   |  `1Gi`                                 |
| `persistence.training.storageClass`           | Storage class used for training data (must support for `ReadWriteMany` access mode)       |  `*globalStorageClass`                 |
| `persistence.training.path`                   | Path to mount the training data volume at                                                     |  `/data/training`                      |
| `persistence.training.size`                   | Size of the training data volume                                                              |  `1Gi`                                 |
| `persistence.inference.storageClass`          | Storage class used for inference data (must support for `ReadWriteMany` access mode)      |  `*globalStorageClass`                 |
| `persistence.inference.path`                  | Path to mount the inference data volume at                                                    |  `/data/datasets`                      |
| `persistence.inference.size`                  | Size of the inference data volume                                                             |  `1Gi`                                 |
| `endpoint.service.type`                       | Kubernetes service type of the API Endpoint                                                   |  `NodePort`                            |
| `ingress.enabled`                             | Enable the ingress for the API Endpoint service                                               |  `false`                               |
| `ingress.annations`                           | Annotations for the ingress realted with the API Endpoint service                             |  `kubernetes.io/ingress.class: nginx`  |
| `ingress.hosts`                               | Hosts paths for the ingress realted with the API Endpoint service (see example)               |  `nil`                                 |
| `backend.image.repository`                    | Back-end App Docker Image                                                                     |  `dhealth/backend`                     |
| `backend.image.tag`                           | Back-end App Docker Image Tag                                                                 |  `0.1`                                 |
| `backend.admin.username`                      | Username of the administrator of the backend app                                              |  `admin`                               |
| `backend.admin.password`                      | Password of the administrator of the backend app (autogenerated if not defined)               |  `nil`                                 |
| `backend.admin.email`                         | Email of the administrator of the backend app                                                 |  `nil`                                 |
| `backend.replicaCount`                        | Number of replicase of the the backend (Gunicorn) server replicas                             |  `1`                                   |
| `backend.workers`                             | Number of workers of every backend (Gunicorn) server replica                                  |  `3`                                   |
| `backend.allowedHosts`                        | List of `ALLOWED_HOSTS` for the backend Django app                                            |  `*`                                   |
| `backend.corsOriginWhiteList`                 | `CORS_ORIGIN_WHITE_LIST` for the backend Django app                                           |  `nil`                                 |
| `backend.resources`                           | CPU/Memory resource requests/limits of the backend server replica                             |  `nil`                                 |
| `backend.nodeSelector`                        | Node labels for pod assignment of the backend server replicas                                 |  `nil`                                 |
| `backend.tolerations`                         | Tollerations labels for pod assignment of the backend server repliacas                        |  `nil`                                 |
| `backend.affinity`                            | Affinity labels for pod assignment of the backend server replicas                             |  `nil`                                 |
| `celery.acceptContent`                        | A list of comma-separated content-types to allow on Celery workers                            |  `json`                                |
| `celery.taskSerializer`                       | A list of comma-separated serializers to allow on Celery workers                              |  `json`                                |
| `celery.resources`                            | CPU/Memory resource requests/limits of the celery worker replica                              |  `nil`                                 |
| `celery.nodeSelector`                         | Node labels for pod assignment of the celery worker replicas                                  |  `nil`                                 |
| `celery.tolerations`                          | Tolerations labels for pod assignment of the celery worker replicas                         |  `nil`                                 |
| `celery.affinity`                             | Affinity labels for pod assignment of the celery worker replicas                              |  `nil`                                 |

Below you can find the link to the available parameters for the remaining deployment components:

* `nginx`: [https://github.com/bitnami/charts/blob/master/bitnami/nginx/README.md]()
* `broker`: [https://github.com/bitnami/charts/blob/master/bitnami/rabbitmq/README.md]()
* `postgresql`: [https://github.com/bitnami/charts/blob/master/bitnami/postgresql/README.md]()





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
