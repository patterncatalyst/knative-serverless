
# Knative Serving
Knative Serving is ideal for running your application services inside Kubernetes by providing a more simplified deployment
syntax with automated scale-to-zero and scale-out based on HTTP load.  The Knative platform will manage your service's deployments,
revisions, networking and scaling.  Knative Serving exposes your service via an HTTP URL and has a lot of sane defaults for its
configurations.  For many practical use cases you might need to tweak the defaults to your needs and might also need to adjust
the traffic distribution amongst the service revisions. As the Knative Serving Service has the built in ability to automatically
scale down to zero when not in use, it is apt to call it as “serverless service”.

In this section, we are going to deploy a Knative Serving service, see its use of Configuration and Revision,
and practice a blue-green deployment and canary release.

## Basics and Fundamentals

* Deploy a Knative Service
* View the Kubernetes resources created by Knative
* Invoke the deployed Knative Service

## Deploy Service

````Bash
cd $TUTORIAL_HOME/serving
````

Examine the service.yaml then deploy the service:

<tabs>
    <tab title="kn">
        <code-block lang="plain text">
            kn service create greeter --image=quay.io/rhdevelopers/knative-tutorial-greeter:quarkus
        </code-block>
    </tab>
    <tab title="kubectl">
        <code-block lang="plain text">
            kubectl apply -f service.yaml
        </code-block>
    </tab>
</tabs>

After successful deployment of the service we should see a Kubernetes Deployment named similar to
greeter-nsrbr-deployment available:

````Bash
kubectl get deployments
````

> [!NOTE]
> THe actual deployment name may vary in the setup

### Invoke the Service

````Bash
http $(kn service describe greeter -o url)
````

## Knative Resources

The Knative service that we deployed now, creates many Knative resources, the following commands will
help us to query and find those resources.

<tabs>
    <tab title="kn">
        <code-block lang="plain text">
            kn service list
        </code-block>
    </tab>
    <tab title="kubectl">
        <code-block lang="plain text">
            kubectl get services.serving.knative.dev greeter
        </code-block>
    </tab>
</tabs>

### configuration

````Bash
kubectl get configurations.serving.knative.dev greeter
````

### routes

<tabs>
    <tab title="kn">
        <code-block lang="plain text">
            kn route list
        </code-block>
    </tab>
    <tab title="kubectl">
        <code-block lang="plain text">
            kubectl get routes.serving.knative.dev greeter
        </code-block>
    </tab>
</tabs>

### revisions

<tabs>
    <tab title="kn">
        <code-block lang="plain text">
            kn revision list
        </code-block>
    </tab>
    <tab title="kubectl">
        <code-block lang="plain text">
            kubectl get rev \
            --selector=serving.knative.dev/service=greeter \
            --sort-by="{.metadata.creationTimestamp}"
        </code-block>
    </tab>
</tabs>

> [!TIP]
> Add -oyaml to the commands above to see additional details

## Cleanup
<tabs>
    <tab title="kn">
        <code-block lang="plain text">
            kn service delete greeter
        </code-block>
    </tab>
    <tab title="kubectl">
        <code-block lang="plain text">
            kubectl delete services.serving.knative.dev greeter
        </code-block>
    </tab>
</tabs>


