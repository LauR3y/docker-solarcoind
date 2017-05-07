# docker-solarcoind
Docker image to run a full Solarcoin node

## Usage

### Building a new image

To create a docker image run the docker build command as below

```console
$ docker build -t solarcoind .
```

### Running solarcoind in a container

The image is set up so that by default it runs the `solarcoind` command with a data directory `/solarcoin`. On the first run a `solarcoin.conf` file is created with a random rpcpassword.
The simplest way to run solarcoind in a container is the following:

```console
$ docker run --detach --name solarcoin-node solarcoind
```

To stop the container run the command below:

```console
$ docker stop solarcoin-node
```

You can start it again with

```console
$ docker start solarcoin-node
```

And delete it with

```console
$ docker rm solarcoin-node
```

Although you can use the commands above run solarcoind in a new contrainer, the wallet and the solarcoin database would be created in an unnamed volume automatically by docker. A better approach is to create a named volume first and mount it to the `/solarcoin` directory when creating the container.

```console
$ docker volume create solarcoin-data
```

Then start a new container with the volume attached:

```console
$ docker run --detach --name solarcoin-node --volume solarcoin-data:/solarcoin solarcoind
```

### Running commands

Print out the configuration file:

```console
$ docker run -it --rm -v solarcoin-data:/solarcoin solarcoind cat solarcoin.conf
```

### Exposing the JSON RPC server

The docker image creates the a solarcoin.conf file with an RPC server enabled (`listen=1`) on the default port (18181), however, it is not accessible outside the docker container unless you publish it on a port when creating the container. To do so, use the following command:

```console
$ docker run --detach --name solarcoin-node --volume solarcoin-data:/solarcoin --publish 18181:18181 solarcoind
```

Accessing the JSON RPC interface (the rpc password is visible in the solarcoind.conf, see above):
```console
$ curl -v --user solarcoinrpc --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getinfo", "params": [] }' -H 'content-type: text/plain;' localhost:18181
```

Note that by default the allowed rpc IP address range is set to 172.* which is the docker networking ip range. It is not recommended to enable RPC other than localhost access because the username and password is sent in a http clear text.

