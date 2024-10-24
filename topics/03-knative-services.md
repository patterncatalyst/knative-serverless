# Knative Services

Deploy a service with Knative Serving

Let's talk about some basics:

````Bash
kn service create greeter \
  --image=quay.io/rhdevelopers/knative-tutorial-greeter:quarkus
````

Examine the deployments

````Bash
kubectl get deployments
````

Let's invoke the new service

````Bash
http $(kn service describe greeter -o url)
````

> [!NOTE]
> Sometimes the response might not be returned immediately especially when the pod is coming up from dormant state.
> In that case, repeat service invocation.

Check out the Knative resources

````Bash
kn service list
kubectl get configurations.serving.knative.dev greeter
kn route list
kn revision list
````

Cleanup

````Bash
kn service delete greeter
````
