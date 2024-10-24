# Traffic Distribution

Let's apply a blue-green deployment and then a canary deployment

Deploy the blue service:

````Bash
kn service create blue-green-canary \
--image=quay.io/rhdevelopers/blue-green-canary \
--env BLUE_GREEN_CANARY_COLOR="#6bbded" \
--env BLUE_GREEN_CANARY_MESSAGE="Hello"
````
Invoke it:

````Bash
kn service describe blue-green-canary -o url
````

Use the URL to open the service in a browser window.If the service was deployed correctly you should see blue
background browser page, with greeting as Hello.


Twelve-factor app
* 12factor.net defines the twelve-factor app as a methodology for building software-as-a-service apps that:
* Use declarative formats for setup automation, to minimize time and cost for new developers joining the project;
* Have a clean contract with the underlying operating system, offering maximum portability between execution environments;
* Are suitable for deployment on modern cloud platforms, obviating the need for servers and systems administration;
* Minimize divergence between development and production, enabling continuous deployment for maximum agility;
* And can scale up without significant changes to tooling, architecture, or development practices.

The twelve-factor methodology can be applied to apps written in any programming language, and which use any combination
of backing services (database, queue, memory cache, etc).

In line with 12-Factor principle, Knative rolls out new deployment whenever the Service Configuration changes, and
creates immutable version of code and configuration called revision. An example of configuration change could for
e.g. an update of Service image, a change to environment variables or add liveness/readiness probes.

Let us now change the configuration of the service by updating the service environment variable BLUE_GREEN_CANARY_COLOR  
to make the browser display green color with greeting text as Namaste.

````Bash
kn service update blue-green-canary \
--image=quay.io/rhdevelopers/blue-green-canary \
--env BLUE_GREEN_CANARY_COLOR="#5bbf45" \
--env BLUE_GREEN_CANARY_MESSAGE="Namaste"
````

Now invoking the service again using the service URL, will show a green color browser page with greeting Namaste.

Examine the revisions

````Bash
kn revision list
kn revision list -s blue-green-canary
````

Tag the blue
````
kn service update blue-green-canary --tag=blue-green-canary-00001=blue
````
Tag the green
````
kn service update blue-green-canary --tag=blue-green-canary-00002=green
````
Tag the latest
````
kn service update blue-green-canary --tag=@latest=latest
````
Examine the list again
````
kn revision list -s blue-green-canary
````
Now we can get to Blue-Green Deployment
### Blue Green
Knative offers a simple way of switching 100% of the traffic from one Knative service revision (blue) to another newly
rolled out revision (green). If the new revision (e.g. green) has erroneous behavior then it is easy to rollback
the change.

Route all traffic to blue
````
kn service update blue-green-canary --traffic blue=100,green=0,latest=0
````
Check out the traffic
````
kn revision list
````
List the sub-routes
````
kubectl get ksvc blue-green-canary -oyaml \
| yq r - 'status.traffic[].url'
````
Show the pods
````
kubectl get pods
````
Because we can do this traffic routing, we can also split the traffic.

### Canary Release
A Canary release is more effective when you want to reduce the risk of introducing new feature. It allows you a more
effective feature-feedback loop before rolling out the change to your entire user base.

Knative allows you to split the traffic between revisions in increments as small as 1%.

To see this in action, apply the following Knative service definition that will split the traffic 80% to 20% between
blue and green.

Update the service:
````
kn service update blue-green-canary \
--traffic="blue=80" \
--traffic="green=20"
````
Check out the pods

watch 'kubectl get pods'

Cleanup
````
kn service delete blue-green-canary
````