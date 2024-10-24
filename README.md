# Knative Serverless

This documentation walks through learning about how to use Knative.

The intention is to learn Knative locally on your laptop leveraging local tooling.

## Prerequisites
 
- 2 CPUs or more
- 2 GB of free memory
- 20 GB of free disk space
- Good internet connection
- Container or virtual machine manager: Docker, containerd, Podman, VirtualBox, Hyperkit
> [!NOTE]
> All of the testing was done on Minikube on Fedora 40+
> The container environment, Docker or Podman, needs to be running and configured to support 
> the RAM and CPU requirements

Example:

````Bash
minikube config set cpus 6
minikube config set memory 16384
minikube config set kubernetes-version v1.34.0
minikube config set container-runtime containerd
````

### Additional Tools

Here is a list of additional tools used in these docs.  You may have to install them per your platform.

- kubectl
- stern
- yq
- httpie
- hey
- kubectx and kubens
- watch
- kapp
- ytt
- tree
- curl

[Link to my older Minikube docs](https://github.com/patterncatalyst/minikube)

### Install Knative kn Quickstart

Installing Knative.  Works on Linux.  
> [!IMPORTANT]
> Not tested on Mac but should work.  May need to tweek.

[Install Knative CLI](https://knative.dev/docs/install/quickstart-install/#install-the-knative-cli)
[Install Knative Quickstart](https://knative.dev/docs/install/quickstart-install/)

If you want, a simple bash script is in the root directory. 
````Bash
start-minikube.sh
````
Should you be on linux, a simple upgrade bash script is also provided.
````Bash
upgrade-minikube.sh
````
## Get Started Learning Knative or using it for a Demo

- [01 Knative Demo](./topics/01-knative-demo.md)
- [02 Knative and Minikube](./topics/02-knative-minikube.md)
- [03 Knative Services](./topics/03-knative-services.md)
- [04 Knative Scale to Zero](./topics/04-knative-scale-to-zero.md)
- [05 Knative Traffic Distribution](./topics/05-knative-traffic-distribution.md)
- [06 Knative Eventing](./topics/06-knative-eventing.md)
- [07 Knative Functions](./topics/07-knative-functions.md)

### Other interesting bits

- [Knative Client](./topics/knative-client.md)
- [Knative Revisions and Traffic Distribution](./topics/knative-revisions-and-traffic-distribution.md)
- [Knative Serving](./topics/knative-serving.md)
- [Knative Serving Scaling](./topics/knative-serving-scaling.md)