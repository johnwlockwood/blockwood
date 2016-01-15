+++
Categories = ["IoT"]
Tags = ["microservices", "IoT", "Internet of Things", "Raspberry Pi", "Cloud"]
date = "2016-01-14T17:10:00-08:00"
title = "Simple Composable Microservice Messaging"

+++

Building with simple components is easier and more fun. You can quickly build
things that work.

Shortly after plugging my new Sense Hat into my Pi, I wanted to try controlling
it from my laptop with NATS. Here are the results:

<iframe width="560" height="315" src="https://www.youtube.com/embed/UJQGDMmctJE" frameborder="0" allowfullscreen></iframe>

##### Components

1. [NATS](http://nats.io/): a cloud-native messaging protocol.

2. [`txnats`](https://github.com/johnwlockwood/txnats): A python NATS client using Twisted, compatible with PyPy and CPython 2.7 and 3.

3. [Raspberry Pi 2](https://www.raspberrypi.org/)

4. [Sense HAT](https://github.com/RPi-Distro/python-sense-hat) with 8x8 LED matrix 


It took me five minutes to download and run the NATS server on my laptop.
Absolutely no configuration or complex options when launching.
I just downloaded, unpacked, went into its directory and typed:

```
./gnatsd
```

I noted the IP address of my laptop and in the example [`queue_respond.py`](https://github.com/johnwlockwood/txnats/blob/master/example/queue_respond.py)
service on my Raspberry PI, set it as the host. 
From my laptop, I ran the example script [`make_request.py`](https://github.com/johnwlockwood/txnats/blob/master/example/make_requests.py)
with the host set to localhost and the service on the PI started responding.

That achieved distributed, two-way communication between two systems that only
had to know the address of the NATS server.

How simple is that? Pretty fantastic.

#### Twisted: Easier than you think.

Twisted seems to me to have a reputation of being hard to understand and use,
but things have changed: They have come up with simpler, more composable ways 
to do network and concurrent programming with better ways to explain it. 
This is a boon to the Python community. I was able to make a working 
NATS client in an evening.

```python

    host = "demo.nats.io"
    port = 4222
    point = TCP4ClientEndpoint(reactor, host, port)
    nats_protocol = txnats.io.NatsProtocol(verbose=False, on_connect=listen)

    # Because NatsProtocol implements the Protocol interface, Twisted's
    # connectProtocol knows how to connected to the endpoint.
    connecting = connectProtocol(point, nats_protocol)

```

#### Clouds are not solid things.
##### There is a reason they're not called brick houses.

![cloud](/images/storm-clipart-lightening-storm-cloud.png)

NATS is a master piece. It's a text based TCP protocol, meaning
you can easily read the commands being sent and received. It's trivial to 
diagnose because you can go minimal and interact with the server using telnet.

Networking has a lot of things that can go wrong, from wifi interference by 
a microwave to someone tripping over a cable in a data center or a heavy load
on a service. The data may not get there in time or at all, 
and connections will be dropped.

NATS has check the connection built in with PING/PONG, allowing each side
to check the connection. If not, gnats will auto-prune the
subscriber and the client will be able to try another gnatsd host in a cluster.

NATS has publish, subscribe and unsubscribe to limit the messages
received on a subject. This makes it trivial to do a request/reply.

#### Services need to scale

Service workers can subscribe with a queue group to form a distributed 
network of service workers. Add and remove workers at will.
That's easy scaling.

#### Welcoming Open Source [Community](http://nats.io/community/)

The originators of NATS realized it was so useful it deserved more attention
and focus by a larger community. Apcera has built the infrustructure for an
active open source community, starting with superb documentation written in 
markdown, a google group, a slack group and especially helpful for getting
started contributing, community manager [@brianflannery](https://twitter.com/brianflannery).

It's simplicity and speed make it's very exciting to work with.


