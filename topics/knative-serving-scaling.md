# Scaling

* Understand what scale-to-zero is and why it's important
* Configure the scale-to-zero time period
* Configure the autoscaler
* Understand types of autoscaling strategies
* Enable concurrency based autoscaling
* Configure a minimum number of replicas for a service

## Deploy Service

Examine $TUTORIAL_HOME/serving/service.yaml

<tabs>
    <tab title="kn">
        <code-block lang="plain text">
           kn service create greeter --image=quay.io/rhdevelopers/knative-tutorial-greeter:quarkus
        </code-block>
    </tab>
    <tab title="kubectl">
        <code-block lang="plain text">
            kubectl apply -f serving/service.yaml
        </code-block>
    </tab>
</tabs>

After the deployment of the service was successful, we should see a Kubernetes deployment like **greeter-v1-deployment**.

## Invoke Service

````Bash
http $(kn service describe greeter -o url)
````

## Scale to Zero

Assuming that Greeter service has been deployed, once no more traffic is seen going into that service, we’d like to scale this service down to zero replicas. That’s called scale-to-zero.

Scale-to-zero is one of the main properties making Knative a serverless platform. After a defined time of idleness (the so called stable-window) a revision is considered inactive. Now, all routes pointing to the now inactive revision will be pointed to the so-called activator. This reprogramming of the network is asynchronous in nature so the scale-to-zero-grace-period should give enough slack for this to happen. Once the scale-to-zero-grace-period is over, the revision will finally be scaled to zero replicas.

If another request tries to get to this revision, the activator will get it, instruct the autoscaler to create new pods for the revision as quickly as possible and buffer the request until those new pods are created.

By default the scale-to-zero-grace-period is 30s, and the stable-window is 60s. Firing a request to the greeter service will bring up the pod (if it is already terminated, as described above) to serve the request. Leaving it without any further requests will automatically cause it to scale to zero in approx 60-70 secs. There are at least 20 seconds after the pod starts to terminate and before it’s completely terminated. This gives the Kourier Ingress enough time to leave out the pod from its own networking configuration.

For better clarity and understanding let us clean up the deployed Knative resources before going to next section, by running:

````Bash
kn service delete greeter
````

## Auto Scaling

By default Knative Serving allows 100 concurrent requests into a pod. This is defined by the container-concurrency-target-default setting in the configmap config-autoscaler in the knative-serving namespace.

For this exercise let us make our service handle only 10 concurrent requests. This will cause Knative autoscaler to scale to more pods as soon as we run more than 10 requests in parallel against the revision.

Examine $TUTORIAL_HOME/serving/service-10.yaml

The Knative service definition above will allow each service pod to handle max of 10 in-flight requests per pod (configured via autoscaling.knative.dev/target annotation) before automatically scaling to new pod(s).

### Deploy the Service

<tabs>
    <tab title="kn">
        <code-block lang="plain text">
           kn service create prime-generator \
              --concurrency-target=10 \
              --image=quay.io/rhdevelopers/prime-generator:v27-quarkus
        </code-block>
    </tab>
    <tab title="kubectl">
        <code-block lang="plain text">
            kubectl apply -f serving/service-10.yaml
        </code-block>
    </tab>
</tabs>

### Invoke the Service

We will not invoke the service directly as we need to send the load to see the autoscaling.

Open a new terminal and run:

````Bash
watch 'kubectl get pods'
````

### Load the Service

We will now send some load to the greeter service. The command below sends 50 concurrent requests (-c 50) for the next 10s (-z 10s)

````Bash
export SVC_URL=$(kn service describe prime-generator -o url)
hey -c 50 -z 10s "$SVC_URL/?sleep=3&upto=10000&memload=100"
````
After you’ve successfully run this small load test, you will notice the number of greeter service pods will have scaled to 5 or more pods automatically.

The autoscale pods is computed using the formula:

````
totalPodsToScale = actualConcurrency/concurrencyTargetPerPod/utilizationPerPod
````

By default the Knative Service utilization is set to 1.0, hence with this current setting of concurrencyTarget=10 and utilization=1.0, when you receive 50 requests(actualConcurrency) then Knative will scale upto 5 pods i.e. 50/10/1.0.

For more clarity and understanding let us clean up existing deployments before proceeding to next section.

````Bash
kn service delete prime-generator
````

## Minimum Scale

In real world scenarios your service might need to handle sudden spikes in requests. Knative starts each service with a default of 1 replica. As described above, this will eventually be scaled to zero as described above. If your app needs to stay particularly responsive under any circumstances and/or has a long startup time, it might be beneficial to always keep a minimum number of pods around. This can be done via an the annotation autoscaling.knative.dev/minScale.

The following example shows how to make Knative create services that start with a replica count of 2 and never scale below it.

Examine $TUTORIAL_HOME/serving/service-min-max-scale.yaml

* The deployment of this service will always have a minimum of 2 pods.
* Will allow each service pod to handle max of 10 in-flight requests per pod before automatically scaling to new pods.

<tabs>
    <tab title="kn">
        <code-block lang="plain text">
            kn service create prime-generator \
              --concurrency-target=10 \
              --scale-min=2 \
              --image=quay.io/rhdevelopers/prime-generator:v27-quarkus
        </code-block>
    </tab>
    <tab title="kubectl">
        <code-block lang="plain text">
            kubectl apply -f serving/service-min-max-scale.yaml
        </code-block>
    </tab>
</tabs>

After the deployment was successful we should see a Kubernetes Deployment called prime-generator-v2-deployment with two pods available.

Open a new terminal and run the following command :

````Bash
watch 'kubectl get pods'
````

Let us send some load to the service to trigger autoscaling:

````Bash
hey -c 50 -z 10s "$SVC_URL/?sleep=3&upto=10000&memload=100"
````

When all requests are done and if we are beyond the scale-to-zero-grace-period, we will notice that Knative has terminated only 3 out 5 pods. This is because we have configured Knative to always run two pods via the annotation autoscaling.knative.dev/minScale: "2".

## Cleanup

````Bash
kn service delete prime-generator
````

