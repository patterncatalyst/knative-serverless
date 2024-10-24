# Build and Deploy a Knative Function

Create a Knative function with the following:

````
func create -l <language> <function-name>
````

At the terminal navigate to a location to create the function, then execute:

````
func create -l go hello
cd /hello
````

Tree the project.

### Let's build the function

Building a function creates an OCI container image for our function that can be pushed to a container registry.  
It does not run or deploy the function, which can be useful if we want to build a container image for our function
locally, but do not want to automatically run the function or deploy it to a cluster.

In the directory
It will ask for a registry:

docker.io/patterncatalyst

````
func build --registry docker.io/patterncatalyst
````

### Running the function
Running a function creates an OCI container image for our function before running the function in our local environment,
but does not deploy the function to a cluster.  This can be useful if we want to run our function locally for a testing
scenario.

Run the function inside the project directory.
````
func run --registry docker.io/patterncatalyst/hello:latest
````

Invoke it in another terminal window
````
func invoke
````

### Deploy the Function
Deploying a function creates an OCI container image for our function, and pushes this container image to our image
registry.  The function is deployed to the cluster as a Knative service.  Redeploying a function updates the container
image and resulting Service that is running on our cluster.  Functions that have been deployed to the cluster are
accessible on the cluster just like any other Knative Service.

````
func deploy --registry docker.io/patterncatalyst/hello:latest --image docker.io/patterncatalyst/hello:latest
````

Then run:
````
func invoke
````