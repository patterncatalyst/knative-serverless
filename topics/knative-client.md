# Knative Client

[Knative Client](https://github.com/knative/client) is the command line utility aimed at enhancing the developer experience when doing Knative Serving and Eventing tasks.

We will be able to :

* Install Knative Client
* Create, update, list and delete Knative service
* Create, update, list and delete Knative service revisions
* List Knative service routes

> [!WARNING]
> Knative Client (kn) is still under aggressive development, so commands and options might change rapidly.

### Verify the Knative Client

````Bash
kn version
````

### Knative Service Commands

Create a greeter service using kn

````Bash
kn service create greeter --image quay.io/rhdevelopers/knative-tutorial-greeter:quarkus
````

### List Knative Services

````Bash
kn service list
````

### Invoke Service

````Bash
http $(kn service describe greeter -o url)
````
> [!IMPORTANT]
> For all the examples in the tutorial we have configured the Ingress Controller and domain, which will use the domain
> suffix format like <service-name>.<namespace>.<minikube ip>.nip.io.
> If you have not using the Ingress controller configuration then the service has to be invoked
> like http $IP_ADDRESS 'Host:greeter.knativetutorial.example.com', you noticed that we added a Host header to the
> request with value greeter.knativetutorial.example.com.
> This FQDN is automatically assigned to your Knative service by the Knative Routes and uses the following
> format: <service-name>.<namespace>.<domain-suffix>.

### Update Knative Service

To create a new revision using kn is as easy as running another command.

In previous chapter we deployed a new revision of Knative service by adding an environment variable.
Lets try do the same thing with kn to trigger a new deployment:

````Bash
kn service update greeter --env "MESSAGE_PREFIX=Namaste"
````

Invoke the service again.
````Bash
http $(kn service describe greeter -o url)
````

### Describe the Knative Service

````Bash
kn service describe greeter
````

### Describe with verbosity

````Bash
kn service describe greeter -v
````

### Get Service URL

````Bash
kn service describe greeter -o url
````

## Knative Revision Commands

The kn revision commands are used to interact with revision(s) of Knative service

### List Revisions

````Bash
kn revision list
````

### Describe Revision

````Bash
kn revision describe greeter-00001
````

### Delete Revision

````Bash
kn revision delete greeter-00001
````

## Knative Route Commands

### List Routes

````Bash
kn route list
````

## Delete Knative Service

We can also use kn to delte the service that was created, to delete the service named greeter run the command:

````Bash
kn service delete greeter
````