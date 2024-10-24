# Knative Eventing

CloudEvents is a specification for describing event data in a common way. An event might be produced by any number of
sources (e.g. Kafka, S3, GCP PubSub, MQTT) and as a software developer, you want a common abstraction for all
event inputs.

There are three primary usage patterns with Knative Eventing:

Source to Sink

Source to Service provides the simplest getting started experience with Knative Eventing. It provides single
Sink that is, event receiving service --, with no queuing, backpressure, and filtering. The Source to Service
does not support replies, which means the response from the Sink service is ignored. As shown in the Figure 1, the
responsibility of the Event Source it just to deliver the message without waiting for the response from the Sink,
hence I think it will be apt to compare Source to Sink to fire and forget messaging pattern.

Channel and Subscription

With the Channel and Subscription, the Knative Eventing system defines a Channel, which can connect to various backends
such as In-Memory, Kafka and GCP PubSub for sourcing the events. Each Channel can have one or more subscribers in the
form of Sink services as shown in Figure 2, which can receive the event messages and process them as needed.
Each message from the Channel is formatted as CloudEvent and sent further up in the chain to other Subscribers for
further processing. The Channels and Subscription usage pattern does not have the ability to filter messages.

Broker and Trigger

The Broker and Trigger are similar to Channel and Subscription, except that they support filtering of events.
Event filtering is a method that allows the subscribers to show an interest on certain set of messages that flows into
the Broker. For each Broker, Knative Eventing will implicitly create a Knative Eventing Channel. As shown in Figure 3,
the Trigger gets itself subscribed to the Broker and applies the filter on the messages on its subscribed broker.
The filters are applied on the Cloud Event attributes of the messages, before delivering it to the interested
Sink Services(subscribers).

In the eventing related subsections of this tutorial, event sources are configured to emit events every minute with a
PingSource or with a ContainerSource.

The logs could be watched using the command:

````Bash
kubectl logs -f <pod-name> -c user-container
````

Using stern with the command stern -n knativetutorial eventing-hello, to filter the logs further add -c user-container
to the stern command.
````Bash
stern -n knative -c user-container eventing-hello
````

### Event Source
Knative Eventing Sources are software components that emit events. The job of a Source is to connect to, drain, capture
and potentially buffer events; often from an external system and then relay those events to the Sink.

Knative Eventing Sources installs the following four sources out-of-the-box:

````
kubectl api-resources --api-group='sources.knative.dev'
````

Examine the PingSource file eventinghello-source.yaml

* The type of event source, the eventing system deploys a bunch of sources out of the box and it also provides way to
  deploy custom resources spec will be unique per source, per kind

### Event Sink

Knative Eventing Sink is how you specify the event receiver that is the consumer of the event--. Sinks can be
invoked directly in a point-to-point fashion by referencing them via the Event Source’s sink as shown below:

Examine the eventinghello-source.yaml file

* sink can target any Kubernetes Service or
* a Knative Service
* Deployed as "eventinghello"

Let's deploy a sink service:
````
kn service create eventinghello \
  --concurrency-target=1 \
  --image=quay.io/rhdevelopers/eventinghello:0.0.2
````

Now Create the Event Source

````
kn source ping create eventinghello-ping-source \
--schedule "*/2 * * * *" \
--data '{"message": "Thanks for watching Developer Corner"}' \
--sink ksvc:eventinghello
````

Verify it's up and running
````
kn source ping list
````

Cleanup
````
kn source ping delete eventinghello-ping-source
kn service delete eventinghello
````