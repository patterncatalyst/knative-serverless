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

[Install Knative CLI](https://knative.dev/docs/install/quickstart-install/#install-the-knative-cli)
[Install Knative Quickstart](https://knative.dev/docs/install/quickstart-install/)

