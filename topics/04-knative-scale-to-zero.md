# Scale to Zero

Assuming that Greeter service has been deployed, once no more traffic is seen going into that service, we’d like to
scale this service down to zero replicas. That’s called scale-to-zero.

Scale-to-zero is one of the main properties making Knative a serverless platform. After a defined time of idleness
(the so called stable-window) a revision is considered inactive. Now, all routes pointing to the now inactive revision
will be pointed to the so-called activator. This reprogramming of the network is asynchronous in nature so the
scale-to-zero-grace-period should give enough slack for this to happen. Once the scale-to-zero-grace-period is over,
the revision will finally be scaled to zero replicas.

If another request tries to get to this revision, the activator will get it, instruct the autoscaler to create new pods
for the revision as quickly as possible and buffer the request until those new pods are created.

By default the scale-to-zero-grace-period is 30s, and the stable-window is 60s. Firing a request to the greeter service
will bring up the pod (if it is already terminated, as described above) to serve the request. Leaving it without any
further requests will automatically cause it to scale to zero in approx 60-70 secs. There are at least 20 seconds after
the pod starts to terminate and before it’s completely terminated. This gives the Kourier Ingress enough time to leave
out the pod from its own networking configuration.

Let's deploy a new service:

````Bash
kn service create prime-generator \
  --concurrency-target=10 \
  --image=quay.io/rhdevelopers/prime-generator:v27-quarkus
````

In another terminal run:

> [!NOTE]
> kubectl should be mapped to the current instance of kube

````Bash
watch 'kubectl get pods'
````
We will now send some load to the greeter service. The command below sends 50 concurrent requests (-c 50) for the
next 10s (-z 10s)

````Bash
export SVC_URL=$(kn service describe prime-generator -o url)
hey -c 50 -z 10s "$SVC_URL/?sleep=3&upto=10000&memload=100"
````

After you’ve successfully run this small load test, you will notice the number of greeter service pods will have scaled
to 5 or more pods automatically.

The autoscale pods is computed using the formula:

> [!INFORMATION]
> totalPodsToScale = actualConcurrency/concurrencyTargetPerPod/utilizationPerPod

By default the Knative Service utilization is set to 1.0, hence with this current setting of concurrencyTarget=10 and
utilization=1.0, when you receive 50 requests(actualConcurrency) then Knative will scale upto 5 pods i.e. 50/10/1.0.

For more clarity and understanding let us clean up existing deployments before proceeding to next section.

Cleanup

````Bash
kn service delete prime-generator
````