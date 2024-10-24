set -eu

unamestr=$(uname)
echo $unamestr


PROFILE_NAME=${PROFILE_NAME:-knative}
MEMORY=${MEMORY:-16384}
INSECURE_REGISTRY=${INSECURE_REGISTRY:-10.0.0.0/24}
DRIVER=${DRIVER:-docker}
CPUS=${CPUS:-6}

# Mac has fewer cores available
if [ "$unamestr" = "Darwin" ]; then
  CPUS=${CPUS:-3}
  DRIVER=${DRIVER:-hyperkit}
fi

echo "start minikube profile $PROFILE_NAME"
minikube start -p "$PROFILE_NAME" \
--driver="$DRIVER" \
--memory="$MEMORY" \
--cpus="$CPUS" \
--insecure-registry="$INSECURE_REGISTRY" \
--kubernetes-version="v1.30.0" \
--disk-size=50g

# config could be set generally
#minikube config set memory "$MEMORY"
#minikube config set disk-size 50g
#minikube config set cpus "$CPUS"
#minikube config set driver "$DRIVER"
#minikube config set insecure-registry "$INSECURE_REGISTRY"
#minikube config set kubernetes-version "v1.30.0"

echo "minikube addons"
minikube -p $PROFILE_NAME addons enable metrics-server
minikube -p $PROFILE_NAME addons enable dashboard
minikube -p $PROFILE_NAME addons enable ingress
minikube -p $PROFILE_NAME addons enable storage-provisioner

# Should you choose a different namespace name
# kn quickstart minikube --name="$PROFILE_NAME"
# When it asks you if the knative cluster is already installed and do you want to delete and recreate, choose 'N'
echo "kn quickstart minikube"
kn quickstart minikube --name="$PROFILE_NAME"

# The quickstart default will tell you to run against profile 'knative' but it is 'knative'
# After this step, in another terminal run $ minikube tunnel --profile knative

# Once the tunnel is started in another terminal, return the other terminal and press any key to complete the install of knative serving and eventing
# We will install knative functions later in the tutorial/demo

# You should now see the profile when using $ minikube profile list
# And can start the profile again later with $ minikube start -p knative

