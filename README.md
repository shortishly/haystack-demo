# Haystack Demo

This is a simple HTTP microservice that can be used to demonstrate
load balancing in Haystack. The service accepts HTTP GET requests and
responds with the hostname of the container and the HTTP path used in
the request. Haystack provides service discovery and automatic HTTP
load balancing in a Docker environment.

![alt text](https://github.com/shortishly/haystack-demo/raw/master/video/BalancingDemoUI.gif "Haystack UI")



To start a demo microservice:

```shell
docker run --name demo -d shortishly/haystack_demo
```

To make a HTTP request to the microservice:

```shell
curl http://$(docker inspect --format={{.NetworkSettings.IPAddress}} demo)/this/is/a/demo
```

The service responds with the hostname of container that handled the
request and the HTTP path used:

```shell
055ec50fc8da: /this/is/a/demo
```

To start a number of services to demonstrate load balancing in Haystack:

```shell
(for i in {1..5}; do docker run --name demo-$(printf %03d $i) -d shortishly/haystack_demo; done)
```

Start Haystack - replace ```172.16.1.218`` with the location of your
Docker Engine that is
[listening on a tcp port](https://docs.docker.com/engine/quickstart/#bind-docker-to-another-host-port-or-a-unix-socket).

```shell
docker run \
    -p 8080:80 \
    -e DOCKER_HOST=tcp://172.16.1.218:2375 \
    -d \
    --name haystack \
    shortishly/haystack
```

You should now have Haystack and 5 demo microservices running within Docker:

```shell
docker ps --format="{{.Names}}"
haystack
demo-001
demo-002
demo-003
demo-004
demo-005
```

Now start a ```busybox`` that uses Haystack for DNS resolution as follows:

```shell
  docker run \
  --dns=$(docker inspect --format='{{.NetworkSettings.IPAddress}}' haystack) \
  --tty \
  --interactive \
  --rm busybox /bin/sh
```

In the ```busybox``` shell:

```shell
wget -q -O /dev/stdout http://demo.haystack_demo.services.haystack/this/is/a/demo
```

Haystack has registered ```demo.haystack_demo.services.haystack``` in
its own DNS service, and is automatically randomly load balancing any
request to that URL to the ```demo-001```, ```demo-002```,
```demo-003```, ```demo-003```, ```demo-004``` and ```demo-005```
containers.

If you make a number of ```wget``` requests to the same URL you will
get responses from the different containers at random:

```shell
# wget -q -O /dev/stdout http://demo.haystack_demo.services.haystack/load/balancing
d617596e70da: /load/balancing
# wget -q -O /dev/stdout http://demo.haystack_demo.services.haystack/load/balancing
96c6c6f27f03: /load/balancing
# wget -q -O /dev/stdout http://demo.haystack_demo.services.haystack/load/balancing
296b5208edf9: /load/balancing
# wget -q -O /dev/stdout http://demo.haystack_demo.services.haystack/load/balancing
1166e110e70d: /load/balancing
# wget -q -O /dev/stdout http://demo.haystack_demo.services.haystack/load/balancing
9909343b937a: /load/balancing
```

You can verify which services are available in Haystack by curling ```/api/info```:

```shell
curl -s http://$(docker inspect --format='{{.NetworkSettings.IPAddress}}' haystack)/api/info|python -m json.tool
```

Use you bowser to visit the Haystack UI running on your Docker host:

```shell
http://YOUR_DOCKER_HOST:8080/ui
```

